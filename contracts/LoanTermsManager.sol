// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LoanTermsManager is Ownable {
    struct LoanTerm {
        uint256 minAmount;
        uint256 maxAmount;
        uint256 interestRate;
        uint256 minDuration;
        uint256 maxDuration;
        bool isActive;
    }

    mapping(uint256 => LoanTerm) public loanTerms;
    uint256 public termCount;

    event LoanTermAdded(uint256 indexed termId);
    event LoanTermUpdated(uint256 indexed termId);
    event LoanTermDeactivated(uint256 indexed termId);

    constructor(address initialOwner) Ownable(initialOwner) {
        // The Ownable constructor is called with initialOwner
    }

    function addLoanTerm(
        uint256 minAmount,
        uint256 maxAmount,
        uint256 interestRate,
        uint256 minDuration,
        uint256 maxDuration
    ) external onlyOwner {
        termCount++;
        loanTerms[termCount] = LoanTerm(
            minAmount,
            maxAmount,
            interestRate,
            minDuration,
            maxDuration,
            true
        );
        emit LoanTermAdded(termCount);
    }

    function updateLoanTerm(
        uint256 termId,
        uint256 minAmount,
        uint256 maxAmount,
        uint256 interestRate,
        uint256 minDuration,
        uint256 maxDuration
    ) external onlyOwner {
        require(loanTerms[termId].isActive, "Loan term does not exist");
        loanTerms[termId] = LoanTerm(
            minAmount,
            maxAmount,
            interestRate,
            minDuration,
            maxDuration,
            true
        );
        emit LoanTermUpdated(termId);
    }

    function deactivateLoanTerm(uint256 termId) external onlyOwner {
        require(loanTerms[termId].isActive, "Loan term does not exist");
        loanTerms[termId].isActive = false;
        emit LoanTermDeactivated(termId);
    }

    function getLoanTerm(uint256 termId) external view returns (LoanTerm memory) {
        require(loanTerms[termId].isActive, "Loan term does not exist or is inactive");
        return loanTerms[termId];
    }
}