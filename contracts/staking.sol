// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract StakingContract is Ownable {
    address[] public s_allowedTokens; // storage allowed tokens
    address[] public stakers;
    mapping(address => mapping(address => uint256)) public s_stakingBalance;
    mapping(address =>  uint256) public s_uniqueTokensStaked;
    mapping(address => address) public s_tokenPriceFeedMapping;
    IERC20 public dappToken;

    constructor(address _dappToken) Ownable() {
        dappToken = IERC20(_dappToken);
    }
    // unstake token -      DONE !
    // issue token -        DONE !
    // stake token -        DONE !
    // add allowed token -  DONE !
    // getEthValue -        DONE !
    // mocks and tests -    TODO !
    // reentrancy attack proof - TODO !
    function stakeTokens(uint256 amount, address token) public{
        require(amount > 0, "StakingContract: amount should be greater than 0");
        require(tokenIsAllowed(token), "StakingContract: token not allowed");
        // transfer the token here
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        updateUniqueTokenStaked(msg.sender, token);
        s_stakingBalance[token][msg.sender] += amount;
        if(s_uniqueTokensStaked[_msgSender()] == 1) {
            stakers.push(_msgSender());
        }
        /* lets think of a bug here
        lets have a contract that has a fallback function and doesnt implement transfer from
        or it does and has our custom implementation
        msg.sender will ... cant think clearly , its related to reentrancy attack , must understand that
        although the bug wont be a problem here since we are allowing only specific tokens
        */

    }

    function unstakeToken(address token) public {
        uint256 balance = s_stakingBalance[token][_msgSender()];
        require(balance > 0);
        IERC20(token).transfer(_msgSender(), balance);
        s_stakingBalance[token][_msgSender()] = 0;
        // s_uniqueTokensStaked[_msgSender()] -= 1; // THIS IS Wrong , because when user re-stakes, he is in the array twice and gets double the rewards
    }

    function updateUniqueTokenStaked(address  user, address token) internal {
        if (s_stakingBalance[token][user] == 0) {
            s_uniqueTokensStaked[user]++;
        }
    }

    function issueTokens() public onlyOwner {
        for(uint256 i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            // send them reward based on TVL
            uint256 userTotalValue = getUserTotalValue(recipient); // TVL across all differnet tokens
            dappToken.transfer(recipient, userTotalValue);
        }
    }

    function getUserTotalValue(address user) public view returns (uint256) {
        uint256 totalValue = 0;
        require(s_uniqueTokensStaked[user] > 0, "StakingContract: No Tokens Staked!");
        for(uint256 i = 0; i < s_allowedTokens.length; i++) {
            totalValue += getUserSingleTokenValue(user, s_allowedTokens[i]);
        }
        return totalValue;

    }

    function getUserSingleTokenValue(address user, address token) public view returns (uint256) {
        // 1 ETH -> 4000$ returns 4000
        // 200 dai -> 200$ returns 200
        // getTokenValue(token) * s_stakingBalance[token][user] // price of token * totalbalance

        (uint256 price, uint256 decimals) = getTokenValue(token);
        return (price * s_stakingBalance[token][user]) / 10**decimals;
    }

    function getTokenValue(address token) public view returns (uint256,uint256) { 
        // price feed
        AggregatorV3Interface priceFeed = AggregatorV3Interface(s_tokenPriceFeedMapping[token]);
        (,int256 price,,,) = priceFeed.latestRoundData();
        uint256 decimals = priceFeed.decimals();
        return (uint256(price), decimals);
    }

    function tokenIsAllowed(address token) public view returns (bool) {
        for(uint256 i = 0; i < s_allowedTokens.length; i++) {
            if (s_allowedTokens[i] == token) {
                return true;
            }
        }
        return false;
    }

    function addAllowedTokens(address token) public onlyOwner {
        s_allowedTokens.push(token);
    }

    function setPriceFeedContract(address token, address priceFeed) public onlyOwner {
        s_tokenPriceFeedMapping[token] = priceFeed;
    }

}