//SPDX-Licensed-Identifier:Undentified;
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../script/DeployMain.s.sol"; // Adjust the path based on your project structure
import {GivingBlock} from "../src/Main.sol";

contract DeployMainTest is Test {
    DeployMain deployMain;
    GivingBlock givingBlock;

    function setUp() public {
        // Initialize the deployment script
        deployMain = new DeployMain();
    }

    function testDeployment() public {
        // Run the deployment script
        deployMain.run();

        // Retrieve the deployed contract
        givingBlock = deployMain.givingBlock();

        // Verify that the contract address is not zero
        assertTrue(
            address(givingBlock) != address(0),
            "Contract not deployed!"
        );
    }
}
