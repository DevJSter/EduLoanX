// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract IncomeVerifier {
    AggregatorV3Interface internal dataFeed;

    constructor(address _oracleAddress) {
        dataFeed = AggregatorV3Interface(_oracleAddress);
    }

    function getLatestIncome() public view returns (int) {
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function isIncomeAboveThreshold(int threshold) public view returns (bool) {
        int latestIncome = getLatestIncome();
        return latestIncome >= threshold;
    }
}