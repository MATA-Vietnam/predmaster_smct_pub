// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ClaimTypes} from "./lib/ClaimTypes.sol";
import {SignatureChecker} from "./lib/SignatureChecker.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RefRewardTour is Ownable {
    using ClaimTypes for ClaimTypes.AdminSignature;

    bytes32 public DOMAIN_SEPARATOR;

    mapping(bytes32 => bool) public claimedAdminSignature;
    mapping(address => uint256) claimed;

    address public tokenReward;

    // Event
    event Claim(address indexed user, uint256 indexed amount);
    event Withdraw(address indexed user, uint256 indexed amount);

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return IERC20(tokenReward).balanceOf(address(this));
    }

    constructor(address _tokenReward) {
        tokenReward = _tokenReward;
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
                0x41d737662ca7bdac85aa4c7986618b072eefe53ae9c903220d0ca77a85d10926, // keccak256("RefReward")
                0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6, // keccak256(bytes("1")) for versionId = 1
                block.chainid,
                address(this)
            )
        );
    }

    function claim(ClaimTypes.AdminSignature calldata adminSignature) external {
        bytes32 hashData = adminSignature.hashAdminSignature();

        require(
            claimedAdminSignature[hashData] == false,
            "Claim: Already claimed"
        );

        // Anti relay attack
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
            claimed[adminSignature.walletAddress];

        require(totalClaim > 0, "Claim: No claim");
        require(getBalance() > 0, "Claim: No balance");

        // transfer eth
        IERC20(tokenReward).transfer(adminSignature.walletAddress, totalClaim);

        //update claimed
        claimed[adminSignature.walletAddress] += totalClaim;
        emit Claim(adminSignature.walletAddress, totalClaim);
    }

    function getTotalClaimed() external view returns (uint256) {
        return claimed[msg.sender];
    }

    function withdraw() external onlyOwner {
        IERC20(tokenReward).transfer(owner(), getBalance());
        emit Withdraw(owner(), getBalance());
    }
}
