// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ClaimTypes
 * @notice This library contains order types for the U2U Event Claim.
 */
library ClaimTypes {
    // keccak256("AdminSignature(address walletAddress,uint256 timestamp,uint256 amount,uint256 week")
    bytes32 internal constant ADMIN_HASH =
        0x14fb216b57795b7141e43108f0a75774ee9bef52d5c56938ef40d925c6d80647;

    struct AdminSignature {
        address walletAddress;
        uint256 timestamp;
        uint256 amount;
        uint256 week;
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
                    adminSignature.amount,
                    adminSignature.week
                )
            );
    }
}
