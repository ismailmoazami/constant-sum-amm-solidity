// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ConstantSumAMM} from "../src/ConstantSumAMM.sol";
import {Script} from "forge-std/Script.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract Deploy is Script {

    function run() external returns(ConstantSumAMM){
        (address token0, address token1) = getConfigs();
        vm.startBroadcast();
        ConstantSumAMM csamm = new ConstantSumAMM(token0, token1);
        vm.stopBroadcast();
        return csamm;
    }

    function getConfigs() internal returns(address token0, address token1){

        if(block.chainid == 11155111) {
            token0 = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9; // weth on sepolia
            token1 = 0x779877A7B0D9E8603169DdbD7836e478b4624789; // link on sepolia
        } else if(block.chainid == 31337) {
            ERC20Mock weth = new ERC20Mock("WETH", "WETH", msg.sender, 100e18);
            ERC20Mock link = new ERC20Mock("LINK", "LINK", msg.sender, 100e18);
            token0 = address(weth);
            token1 = address(link);
        }

    }

}