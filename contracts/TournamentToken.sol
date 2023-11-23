// erc20 token
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import {ClaimTypes} from "./lib/ClaimTypesTour.sol";
import {SignatureChecker} from "./lib/SignatureChecker.sol";

contract TournamentToken is ERC20, Ownable {
    using ClaimTypes for ClaimTypes.AdminSignature;

    bytes32 public DOMAIN_SEPARATOR;

    mapping(bytes32 => bool) public claimedAdminSignature;
    mapping(address => uint256) claimed;
    mapping(uint256 => mapping(address => bool)) userWeekClaimed;

    mapping(address => bool) claimedTestToken;

    uint256 public startTime = 0;

    // Event
    event Claim(address indexed user, uint256 indexed amount, uint256 week);

    mapping(address => bool) public operator;

    constructor() ERC20("PredMaster Tournament Token", "PMT") {
        operator[msg.sender] = true;
        operator[address(this)] = true;
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f, // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
                0xb29fc7cedb019492cbc2c31647d840497b73574fab06e2f698106d1c17196158, // keccak256("TournamentToken")
                0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6, // keccak256(bytes("1")) for versionId = 1
                block.chainid,
                address(this)
            )
        );
    }

    function mint() external onlyOwner {
        _mint(msg.sender, 10000000000 ether);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        require(
            operator[from] == true || operator[to] == true,
            "Transfer: Not allow"
        );
        super._beforeTokenTransfer(from, to, amount);
    }

    function claim(ClaimTypes.AdminSignature calldata adminSignature) external {
        bytes32 hashData = adminSignature.hashAdminSignature();

        require(block.timestamp >= startTime, "Claim: Not start yet");
        require(
            claimedAdminSignature[hashData] == false,
            "Claim: Already claimed"
        );
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

        claimedAdminSignature[hashData] = true;

        uint256 totalClaim = adminSignature.amount;

        require(totalClaim > 0, "Claim: No claim");
        require(
            userWeekClaimed[adminSignature.week][
                adminSignature.walletAddress
            ] == false,
            "Claim: Already claimed"
        );

        _mint(adminSignature.walletAddress, totalClaim);

        //update claimed
        claimed[adminSignature.walletAddress] += totalClaim;

        userWeekClaimed[adminSignature.week][
            adminSignature.walletAddress
        ] = true;

        emit Claim(
            adminSignature.walletAddress,
            totalClaim,
            adminSignature.week
        );
    }

    function checkUserWeekClaimed(
        uint256 week,
        address user
    ) external view returns (bool) {
        return userWeekClaimed[week][user];
    }

    function claimTestToken() external {
        require(
            claimedTestToken[msg.sender] == false,
            "Claim: Already claimed"
        );
        _mint(msg.sender, 10 ether);
        //update claimed
        claimedTestToken[msg.sender] = true;
    }

    function setOperator(address _operator, bool _status) external onlyOwner {
        operator[_operator] = _status;
    }

    function setStartTime(uint256 _startTime) external onlyOwner {
        startTime = _startTime;
    }
}
