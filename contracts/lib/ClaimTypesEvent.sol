// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ClaimTypes
 * @notice This library contains order types for the U2U Event Claim.
 */
library ClaimTypesEvent {
    // keccak256("AdminSignature(address walletAddress,uint256 timestamp,uint256 amount,uint256 claimType")
    bytes32 internal constant ADMIN_HASH =
        0x68f432cf99130c8f8b49eb8f3932135ea1559ef7e2ac2b7a085708a5781ce913;

    struct AdminSignature {
        address walletAddress;
        uint256 timestamp;
        uint256 amount;
        uint256 claimType;
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
                    adminSignature.claimType
                )
            );
    }
}
