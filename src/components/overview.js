import { Contract } from "ethers";
import { SendButton } from "./sendPopup";
import { ERC20ABI } from "@/contract";
import { getInstance, getSignature } from "@/utils/fhEVM";
import { CoinsIcon, PiggyBankIcon } from "lucide-react";
import { useEffect, useState } from "react";
import Loader from "./loader";
import { RequestButton } from "./requestPopup";
import BurnToken from "./burnPopup";
import { useSelector } from "react-redux";
import WrapToken from "./wrapToken";

const { default: Image } = require("next/image");
const { Button } = require("./ui/button");

export const Overview = () => {
  
  const loanBalance = 10000;
  const repaidAmount = 2000;
  const isLoading = false;

  // Placeholder functions - replace with actual implementations
  const handleApplyLoan = () => console.log('Apply for loan');
  const handleRepayLoan = () => console.log('Repay loan');

  return (
    <div className="mt-8 px-8">
      <h1 className="text-3xl font-semibold">EduLoanX Overview</h1>
      <div className="mt-8 p-4 py-6 bg-white rounded-lg flex drop-shadow-sm">
        <img src="/eduLoanX-logo.svg" width="305" height="247" alt="EduLoanX Logo" className="object-contain" />
        <div className="w-full grid grid-cols-2">
          <div className="border-r w-full flex items-center justify-center">
            <div>
              <div className="flex items-center gap-3">
                <img src="/icons/loan.svg" width="16" height="16" alt="Loan Icon" />
                <p className="font-medium text-gray-600">Current Loan Balance</p>
              </div>

              <div>
                {isLoading ? (
                  <div className="h-28 grid place-items-center">
                    <p>Loading...</p>
                  </div>
                ) : (
                  <div className="flex items-center mt-1">
                    <div className="text-7xl font-semibold text-blue-600">
                      ${loanBalance.toLocaleString()}
                    </div>
                  </div>
                )}

                <div className="flex items-center gap-4 mt-4">
                  <button onClick={handleApplyLoan} className="bg-blue-600 text-white px-4 py-2 rounded">
                    Apply for Loan
                  </button>
                  <button onClick={handleRepayLoan} className="bg-green-600 text-white px-4 py-2 rounded">
                    Repay Loan
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div className="w-full flex items-center px-14">
            <div>
              <div className="flex items-center gap-3">
                <img src="/icons/repayment.svg" width="16" height="16" alt="Repayment Icon" />
                <p className="font-medium text-gray-600">Total Repaid Amount</p>
              </div>

              {isLoading ? (
                <div className="h-28 grid place-items-center">
                  <p>Loading...</p>
                </div>
              ) : (
                <div className="flex items-center mt-1">
                  <div className="text-7xl font-semibold text-green-600">
                    ${repaidAmount.toLocaleString()}
                  </div>
                </div>
              )}
              <div className="mt-4">
                <p className="text-sm text-gray-600">
                  Next payment due: 15th Aug 2024
                </p>
                <p className="text-sm text-gray-600">
                  Interest rate: 5.5%
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
