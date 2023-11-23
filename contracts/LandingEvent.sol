// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ClaimTypesEvent} from "./lib/ClaimTypesEvent.sol";
import {SignatureChecker} from "./lib/SignatureChecker.sol";

import {TournamentToken} from "./TournamentToken.sol";
import {PRED} from "./PRED.sol";

contract LandingEvent is Ownable {
    using ClaimTypesEvent for ClaimTypesEvent.AdminSignature;

    bytes32 public DOMAIN_SEPARATOR;

    mapping(bytes32 => bool) public claimedAdminSignature;
    mapping(uint256 => mapping(address => uint256)) claimed;

    TournamentToken public tokenPMT;
    PRED public tokenPRED;

    uint256 tokenId = 0;

    bool isEnd = false;

    struct responseCheckClaimed {
        uint256 typeClaim;
        uint256 amount;
    }

    event ClaimToken(address indexed user, uint256 indexed amount);

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    constructor() {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
                0x583043024cc44c41d12f7b5c0503ea940dc6944173a61733b64c00330fa1c498, // keccak256("LandingEvent")
                0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6, // keccak256(bytes("1")) for versionId = 1
                block.chainid,
                address(this)
            )
        );
    }

    function claim(
        ClaimTypesEvent.AdminSignature calldata adminSignature
    ) external {
        bytes32 hashData = adminSignature.hashAdminSignature();
        require(isEnd == false, "Claim: End");
        require(
            claimedAdminSignature[hashData] == false,
            "Claim: Already claimed"
        );

        // Anti replay attack
        claimedAdminSignature[hashData] = true;

        require(
            SignatureChecker.verify(
                hashData,
                owner(),
                adminSignature.v,
                adminSignature.r,
                adminSignature.s,
                DOMAIN_SEPARATOR
            ),
            "Signature: Invalid for admin"
        );

        uint256 totalClaim = adminSignature.amount -
            claimed[adminSignature.claimType][adminSignature.walletAddress];

        require(totalClaim > 0, "Claim: No claim");

        if (adminSignature.claimType == 1) {
            tokenPMT.transfer(adminSignature.walletAddress, totalClaim);
            tokenPRED.mint(adminSignature.walletAddress, totalClaim);

            emit ClaimToken(msg.sender, totalClaim);
        }

        claimed[adminSignature.claimType][
            adminSignature.walletAddress
        ] += totalClaim;
    }

    function getTotalClaimedByTypeAndUser(
        uint256 typeClaim
    ) public view returns (responseCheckClaimed memory) {
        responseCheckClaimed memory result;

        result.typeClaim = typeClaim;
        result.amount = claimed[typeClaim][msg.sender];

        return result;
    }

    function setToken(address _token1, address _token2) public onlyOwner {
        tokenPMT = TournamentToken(_token1);
        tokenPRED = PRED(_token2);
    }

    function setEnd(bool status) public onlyOwner {
        isEnd = status;
    }
}
