// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//@notics Contracts must implement this interface to make flash loans using FlashLoanSimplified
interface FlashBorrower{
    function onFlashLoan(
        ERC20 token,
        uint256 amount,
        bytes calldata data
    )external;
}

contract FlashLoanSimplified{

    //ERRORS

    error Unauthorized();
    error TokensNotReturned();
    error InvalidPercentage();
  

    //EVENTS

    event Withdrawn(ERC20 indexed token, uint256 amount);

    event FeeUpdated(ERC20 indexed token, uint256 fee);

    event FlashLoaned(FlashBorrower indexed receiver, ERC20 indexed token, uint256 amount);

    address public immutable owner;

    //@notice a list of fee percentages for each token, multiplied by 100 to avoid decimals (eg: 10% is 10_00)
    mapping(ERC20 => uint256) public fees;

    //@deploys a FlashLoansimplified and sets the deployer as owner
    constructor() payable{
        owner = msg.sender;
    }

    function getFee(ERC20 token, uint256 amount) public view returns (uint256){
        if(fees[token] == 0) return 0;
        return (amount * fees[token]) / 10_000;

    }

    function execute(
        FlashBorrower receiver,
        ERC20 token,
        uint256 amount,
        bytes calldata data
    ) public payable{
        uint256 currentBalance = token.balanceOf(address(this));
         emit FlashLoaned(receiver, token, amount);

         token.transfer(address(receiver), amount);
         receiver.onFlashLoan(token, amount, data);

         if(currentBalance + getFee() > token.balanceOf(address(this)));
         revert TokensM

    }

    function setFee(ERC20 token, uint256 fee) public payable{
        if(msg.sender != owner) revert Unauthorized();
        if(fee > 100_00) revert InvalidPercentage();

        emit FeeUpdated(token, fee);

        fees[token] = fee;

    }
    function withdraw(ERC20 toke, uint256 amount) public payable{
        if(msg.sender!= owner) revert Unauthorized();

        emit Withdrawn(token, amount);
        token.transfer(msg.sender, amount);

    }
}


