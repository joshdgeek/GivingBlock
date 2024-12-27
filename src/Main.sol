// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract GivingBlock {
    address[] public santaHelpers;
    address[] public donors;
    uint256 public contractBalance;
    mapping(address => uint256) public helperBalance;
    mapping(address => bool) private isDonor;
    mapping(address => bool) private isHelper;

    //event for payment confirmation
    event PaymentReceived(address indexed donor, address indexed elf, uint256 amount);

    //event to
    event santaHelpersRegistration(bool isHelper_bool, string message);

    function joinSantaHelpers(address becomeAnElf) public {
        if (!isHelper[becomeAnElf]) {
            santaHelpers.push(becomeAnElf);
            isHelper[becomeAnElf] = true;
            emit santaHelpersRegistration(true, "You are now on the list");
        } else {
            emit santaHelpersRegistration(false, "You are already on the list");
        }
    }

    function isHelperPublic(address addr) public view returns (bool) {
        return isHelper[addr];
    }

    function grantWish(address elf) public payable {
        require(msg.value >= 1 ether, "Please enter minimum amount of ether");
        require(isHelper[elf], "Recipient must be a registered Santa helper");

        //project fees
        uint256 amountInPercentage = 3;
        uint256 actualFee = (msg.value * amountInPercentage) / 100;

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
        require(helperBalance[msg.sender] > 0 ether, "must have ether to make withdrawal");

        uint256 amount = helperBalance[msg.sender];
        helperBalance[msg.sender] = 0;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "transfer failed");
    }
}
