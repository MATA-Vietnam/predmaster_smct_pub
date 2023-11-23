// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ClaimTypes} from "./lib/ClaimTypes.sol";
import {SignatureChecker} from "./lib/SignatureChecker.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TournamentMarket is Ownable {
    IERC20 public stableToken;

    uint256 startTime = 1698624000; //Monday, October 30, 2023 12:00:00 AM

    uint256 timeOneWeek = 86400 * 7; // 1 week
    uint256 price = 1 ether;
    uint256 totalToken = 100 ether;

    mapping(uint256 => mapping(address => bool)) buyHistory;

    bool public isEnd = false;

    // EVENT
    event Buy(address user, uint256 amount);

    constructor(address _stableToken) {
        stableToken = IERC20(_stableToken);
    }

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

    function buy(uint256 week) public {
        require(buyHistory[week][msg.sender] == false, "Claim: Already buy");
        require(week <= getDayWeek(), "Claim: Not yet");
        require(isEnd == false, "Claim: End");
        buyHistory[week][msg.sender] = true;
        stableToken.transferFrom(msg.sender, address(this), price);
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
        stableToken.transfer(msg.sender, stableToken.balanceOf(address(this)));
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
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
            buyHistory[week][user[index]] = true;
        }
    }
}
