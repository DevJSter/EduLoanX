// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Custom interface for Aave V2 LendingPool
interface IAaveLendingPool {
    function deposit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;

    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns (uint256);
}

contract AaveLiquidityManager {
    IAaveLendingPool public lendingPool;
    IERC20 public daiToken;

    constructor(address _lendingPoolAddress, address _daiTokenAddress) {
        lendingPool = IAaveLendingPool(_lendingPoolAddress);
        daiToken = IERC20(_daiTokenAddress);
    }

    function deposit(uint256 amount) external {
        daiToken.transferFrom(msg.sender, address(this), amount);
        daiToken.approve(address(lendingPool), amount);
        lendingPool.deposit(address(daiToken), amount, address(this), 0);
    }

    function withdraw(uint256 amount) external {
        lendingPool.withdraw(address(daiToken), amount, msg.sender);
    }
}