// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import  "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract StakingContract {
            IERC20 public immutable stakingToken;

    constructor(address _stakingTokenAddr) {
        stakingToken = IERC20(_stakingTokenAddr);
    }
       // IERC20 public immutable rewardsToken;


    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public rewardsBalance;
    mapping(address => uint256) public lastStakeTime;

    uint256 public totalStaked;
    uint256 public totalRewards;

    // Events for logging
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    // Function to stake tokens
    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        // Update staking balances
        stakedBalance[msg.sender] += amount;
        totalStaked += amount;
        lastStakeTime[msg.sender] = block.timestamp;
        // Transfer tokens from user to contract
        stakingToken.transferFrom(msg.sender, address(this), amount);

        emit Staked(msg.sender, amount);
    }

    // Function to unstake tokens
    function unstake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(stakedBalance[msg.sender] >= amount, "Insufficient staked balance");

        // Calculate rewards earned
        uint256 rewards = calculateRewards(msg.sender);

        // Update staking balances
        stakedBalance[msg.sender] -= amount;
        totalStaked -= amount;
            
        // Transfer staked tokens back to user
        stakingToken.transfer(address(this), amount);

        // Update rewards balances
        rewardsBalance[msg.sender] += rewards;
        totalRewards += rewards;

        emit Unstaked(msg.sender, amount);
    }

    // Function to claim rewards
    function claimRewards() external {
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "No rewards to claim");

        // Transfer rewards tokens to user
        stakingToken.transfer(address(this), rewards);

        // Update rewards balances
        rewardsBalance[msg.sender] += rewards;
        totalRewards += rewards;

        emit RewardsClaimed(msg.sender, rewards);
    }

    // Internal function to calculate rewards
    function calculateRewards(address user) internal view returns (uint256) {
        // Calculate rewards based on staking duration and amount
        // Simplified for demonstration purposes
        uint256 timeSinceLastStake = block.timestamp - lastStakeTime[user];
        uint256 rewards = (stakedBalance[user] * timeSinceLastStake) / 1000; // Example formula

        return rewards;
    }
}
contract UtitlityToken is ERC20 {  
    constructor(string memory _tokenName, string memory _tokenSymbol, uint _decimal)
     ERC20(_tokenName, _tokenSymbol) {}  

           function mint(address user, uint256 amount) public {
            _mint(user, amount);    
            }
}