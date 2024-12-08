// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {GivingBlock} from "../src/Main.sol";

contract DeployMain is Script {
    GivingBlock public givingBlock;

    function setup() public {}

    function run() public {
        vm.startBroadcast();
        givingBlock = new GivingBlock();
        vm.stopBroadcast();
    }
}
