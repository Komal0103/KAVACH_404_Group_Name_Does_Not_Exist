// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Transactions{
    uint256 transactionCounter;
    event Transfer(address from, address receiver, uint amount, string message, uint256 timestamp, string keyword);
    struct TransferStruct {
        address sender;
        address receiver;
        uint amount;
        string message;
        uint timestamp;
        string keyword;
    }
    TransferStruct[] transactions;

    function add(address payable receiver, uint amount, string memory message, string memory keyword) public{
        transactionCounter+=1;
        // timestamp of the particular block that was being executed on the blockchain
        transactions.push(TransferStruct(msg.sender, receiver, amount, message, block.timestamp, keyword));

        emit Transfer(msg.sender, receiver, amount, message, block.timestamp, keyword);
    }
    function getTransactions() public view returns (TransferStruct[] memory){
        return transactions;
    }
    function getTransactionCount() public view returns (uint256){
        return transactionCounter;
    }
}