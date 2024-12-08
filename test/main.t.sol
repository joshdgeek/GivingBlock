//SPDX-Licensed-Identifier:Undentified;
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {GivingBlock} from "../src/Main.sol";
import {DeployMain} from "../script/DeployMain.s.sol";

contract testMainApp is Test {
    GivingBlock givingBlock;
    address admin;
    address donor;
    address santaHelper;

    function setUp() external {
        //ANVIL TEST ADDRESSES
        admin = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        donor = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        santaHelper = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;

        vm.startPrank(admin);
        givingBlock = new GivingBlock();
        vm.stopPrank();
    }

    function testjoinSantaHelpers() public {
        givingBlock.joinSantaHelpers(santaHelper);

        assertEq(givingBlock.isHelperPublic(santaHelper), true);
    }

    function testPayment() public {
        givingBlock.joinSantaHelpers(santaHelper);
        vm.prank(donor);
        vm.deal(donor, 2 ether);
        givingBlock.grantWish{value: 1 ether}(santaHelper);

        assertEq(givingBlock.donors(0), donor);
    }

    // test the contract balance after every transaction
    function testContractBalance() public {
        givingBlock.joinSantaHelpers(santaHelper);
        vm.prank(donor);
        vm.deal(donor, 2 ether);
        givingBlock.grantWish{value: 1 ether}(santaHelper);
        assertEq(givingBlock.contractBalance(), 0.03 ether);
        assertEq(givingBlock.helperBalance(santaHelper), 0.97 ether);
    }

    function testWithdrawals() public {
        givingBlock.joinSantaHelpers(santaHelper);
        vm.prank(donor);
        vm.deal(donor, 3 ether);
        givingBlock.grantWish{value: 1 ether}(santaHelper);

        vm.prank(santaHelper);
        givingBlock.withdrawFunds();
        assertEq(givingBlock.contractBalance(), 0.03 ether);
        assertEq(givingBlock.helperBalance(santaHelper), 0 ether);
    }
}
