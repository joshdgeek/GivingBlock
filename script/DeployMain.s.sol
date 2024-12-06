// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Main} from "../src/Main.sol";

contract DeployMain is Script {
    Main public main;

    function setup() public {}

    function run() public {
        vm.startBroadcast();
        main = new Main();
        vm.stopBroadcast();
    }
}
