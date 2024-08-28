// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./IncomeVerifier.sol";
import "./AaveLiquidityManager.sol";
import "./LoanTermsManager.sol";

contract EduLoanXMain is Ownable, Pausable, ReentrancyGuard {
    SponsorToken public sponsorToken;
    StudentToken public studentToken;
    IncomeVerifier public incomeVerifier;
    AaveLiquidityManager public aaveLiquidityManager;
    LoanTermsManager public loanTermsManager;

    struct Loan {
        uint256 amount;
        uint256 interestRate;
        uint256 dueDate;
        uint256 paidAmount;
        bool isApproved;
        bool isFullyRepaid;
        uint256 termId;
    }

    mapping(address => Loan) public loans;
    mapping(address => bool) public approvedSponsors;

    event LoanRequested(address indexed student, uint256 amount, uint256 termId);
    event LoanApproved(address indexed student, uint256 amount);
    event LoanRepayment(address indexed student, uint256 amount);
    event SponsorApproved(address indexed sponsor);
    event SponsorRemoved(address indexed sponsor);

    constructor(
        address _sponsorToken,
        address _studentToken,
        address _incomeVerifier,
        address _aaveLiquidityManager,
        address _loanTermsManager,
        address initialOwner
    ) Ownable(initialOwner) {
        sponsorToken = SponsorToken(_sponsorToken);
        studentToken = StudentToken(_studentToken);
        incomeVerifier = IncomeVerifier(_incomeVerifier);
        aaveLiquidityManager = AaveLiquidityManager(_aaveLiquidityManager);
        loanTermsManager = LoanTermsManager(_loanTermsManager);
    }

    function requestLoan(uint256 amount, uint256 termId) public whenNotPaused {
        require(loans[msg.sender].amount == 0, "Existing loan must be repaid first");
        LoanTermsManager.LoanTerm memory term = loanTermsManager.getLoanTerm(termId);
        require(amount >= term.minAmount && amount <= term.maxAmount, "Loan amount out of range");
        
        loans[msg.sender] = Loan(
            amount,
            term.interestRate,
            block.timestamp + term.maxDuration,
            0,
            false,
            false,
            termId
        );
        emit LoanRequested(msg.sender, amount, termId);
    }

    function approveLoan(address student) public onlyOwner {
        Loan storage loan = loans[student];
        require(!loan.isApproved, "Loan already approved");
        require(loan.amount > 0, "No loan request found");
        require(incomeVerifier.isIncomeAboveThreshold(int(loan.amount)), "Income verification failed");
        
        loan.isApproved = true;
        studentToken.mint(student, loan.amount);
        aaveLiquidityManager.withdraw(loan.amount);
        emit LoanApproved(student, loan.amount);
    }

    function repayLoan() public payable nonReentrant {
        Loan storage loan = loans[msg.sender];
        require(loan.isApproved, "No approved loan found");
        require(!loan.isFullyRepaid, "Loan already fully repaid");

        uint256 repaymentAmount = msg.value;
        require(repaymentAmount > 0, "Repayment amount must be greater than 0");

        uint256 remainingAmount = loan.amount + (loan.amount * loan.interestRate / 100) - loan.paidAmount;
        uint256 actualRepayment = repaymentAmount > remainingAmount ? remainingAmount : repaymentAmount;

        loan.paidAmount += actualRepayment;
        if (loan.paidAmount >= loan.amount + (loan.amount * loan.interestRate / 100)) {
            loan.isFullyRepaid = true;
        }

        studentToken.burn(msg.sender, actualRepayment);
        aaveLiquidityManager.deposit(actualRepayment);

        if (repaymentAmount > actualRepayment) {
            payable(msg.sender).transfer(repaymentAmount - actualRepayment);
        }

        emit LoanRepayment(msg.sender, actualRepayment);
    }

    function getLoanDetails(address student) public view returns (Loan memory) {
        return loans[student];
    }

    function approveSponsor(address sponsor) public onlyOwner {
        approvedSponsors[sponsor] = true;
        emit SponsorApproved(sponsor);
    }

    function removeSponsor(address sponsor) public onlyOwner {
        approvedSponsors[sponsor] = false;
        emit SponsorRemoved(sponsor);
    }

    function pausePlatform() public onlyOwner {
        _pause();
    }

    function unpausePlatform() public onlyOwner {
        _unpause();
    }

    // Function to allow contract to receive ETH
    receive() external payable {}
}