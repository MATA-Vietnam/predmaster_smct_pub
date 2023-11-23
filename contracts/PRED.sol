// erc20 token
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PRED is ERC20, ERC20Burnable, Ownable {
    mapping(address => bool) public operator;

    constructor() ERC20("PRED", "PRED") {}

    function mint(address to, uint256 amount) public onlySystem {
        return _mint(to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function setOperator(address[] memory _operator) public onlySystem {
        for (uint256 index = 0; index < _operator.length; index++) {
            operator[_operator[index]] = true;
        }
    }

    modifier onlySystem() {
        require(
            owner() == msg.sender || operator[msg.sender] == true,
            "U2UEventToken: caller is not the owner"
        );
        _;
    }
}
