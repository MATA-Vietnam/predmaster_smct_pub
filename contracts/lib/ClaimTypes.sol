// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ClaimTypes
 * @notice This library contains order types for the U2U Event Claim.
 */
library ClaimTypes {
    // keccak256("AdminSignature(address walletAddress,uint256 timestamp,uint256 amount")
    bytes32 internal constant ADMIN_HASH =
        0xdafd8e0fa61c5d392d2d0fae04e7c2ae6ccbaff740fd8a77d275daaf4498bcde;

    struct AdminSignature {
        address walletAddress;
        uint256 timestamp;
        uint256 amount;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    function hashAdminSignature(
        AdminSignature memory adminSignature
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    ADMIN_HASH,
                    adminSignature.walletAddress,
                    adminSignature.timestamp,
                    adminSignature.amount
                )
            );
    }
}
