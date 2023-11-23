// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ClaimTypes} from "./lib/ClaimTypes.sol";
import {SignatureChecker} from "./lib/SignatureChecker.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {NftTicket} from "./NftTicket.sol";

contract TournamentTicket is Ownable {
    uint256 startTime = 1699257600; //Monday, November 6, 2023 8:00:00 AM

    uint256 timeOneWeek = 86400 * 7; // 1 week
    uint256 gasFee = 0.0045 ether;
    uint256 totalToken = 100 ether;

    address public nftTicketAddress;

    mapping(uint256 => mapping(address => bool)) buyHistory;

    bool public isEnd = false;

    receive() external payable {}

    // EVENT
    event Buy(address user, uint256 amount);

    function getDayWeek() public view returns (uint256) {
        if (block.timestamp < startTime) return 0;
        return (block.timestamp - startTime) / timeOneWeek;
    }

    function getHistoryUser() public view returns (bool[] memory) {
        bool[] memory history = new bool[](getDayWeek() + 1);
        for (uint256 index = 0; index <= getDayWeek(); index++) {
            history[index] = bool(buyHistory[index][msg.sender]);
        }
        return history;
    }

    function getHistoryUserByWeek(uint256 week) public view returns (bool) {
        return buyHistory[week][msg.sender];
    }

    function buy(uint256 week) public payable {
        require(buyHistory[week][msg.sender] == false, "Claim: Already buy");
        require(week <= getDayWeek(), "Claim: Not yet");
        require(isEnd == false, "Claim: End");
        require(msg.value >= gasFee, "Not enough gas fee");

        if (NftTicket(nftTicketAddress).balanceOf(msg.sender) == 0) {
            NftTicket(nftTicketAddress).mint(msg.sender);
        }

        buyHistory[week][msg.sender] = true;
        emit Buy(msg.sender, totalToken);
    }

    function buyAll() public {
        for (uint256 index = 0; index <= getDayWeek(); index++) {
            if (buyHistory[index][msg.sender] == false) {
                buy(index);
            }
        }
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setGas(uint256 _gas) public onlyOwner {
        gasFee = _gas;
    }

    function setTotalToken(uint256 _totalToken) public onlyOwner {
        totalToken = _totalToken;
    }

    function setStartTime(uint256 _startTime) public onlyOwner {
        startTime = _startTime;
    }

    function setEnd(bool _isEnd) public onlyOwner {
        isEnd = _isEnd;
    }

    function setBuyed(uint256 week, address[] memory user) public onlyOwner {
        for (uint256 index = 0; index < user.length; index++) {
            if (NftTicket(nftTicketAddress).balanceOf(user[index]) == 0) {
                NftTicket(nftTicketAddress).mint(user[index]);
            }
            buyHistory[week][user[index]] = true;
        }
    }

    function setNftAddress(address _nftTicketAddress) public onlyOwner {
        nftTicketAddress = _nftTicketAddress;
    }
}
