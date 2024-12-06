// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract GivingBlock {
    address[] public santaHelpers;
    address[] public donors;
    uint public contractBalance;
    mapping(address => uint) public helperBalance;
    mapping(address => bool) private isDonor;
    mapping(address => bool) private isHelper;

    //event for payment confirmation
    event PaymentReceived(
        address indexed donor,
        address indexed elf,
        uint amount
    );

    function joinSantaHelpers(address becomeAnElf) public {
        if (!isHelper[becomeAnElf]) {
            santaHelpers.push(becomeAnElf);
            isHelper[becomeAnElf] = true;
        }
    }

    function grantWish(address elf) public payable {
        require(msg.value >= 1 ether, "Please enter minimum amount of ether");
        require(isHelper[elf], "Recipient must be a registered Santa helper");

        //project fees
        uint amountInPercentage = 3;
        uint actualFee = (msg.value * amountInPercentage) / 100;

        //track helpers and donors
        if (!isDonor[msg.sender]) {
            donors.push(msg.sender);
            isDonor[msg.sender] = true;
        }

        //keep track of donor's and contract's balance after every transaction
        helperBalance[elf] += (msg.value - actualFee);
        contractBalance += actualFee;

        emit PaymentReceived(msg.sender, elf, msg.value);
    }

    function withdrawFunds() external {
        require(
            helperBalance[msg.sender] > 0 ether,
            "must have ether to make withdrawal"
        );

        uint amount = helperBalance[msg.sender];
        helperBalance[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "transfer failed");
    }
}