// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DrandOracle} from "../src/DrandOracle.sol";

/// @title DeployScript
/// @author Lui Yong Sheng (@luiyongsheng)
/// @notice Deterministic CREATE2 deployment of DrandOracle.
/// @dev Uses a fixed salt so the contract deploys to the same address on every
///      EVM chain (via the keyless CREATE2 factory at
///      0x4e59b44847b379578588920cA78FbF26c0B4956C).
///
///      Usage:
///        forge script script/Deploy.s.sol --rpc-url <RPC> --broadcast
contract DeployScript is Script {
    bytes32 constant SALT = bytes32(uint256(0));

    function run() external {
        vm.startBroadcast();

        DrandOracle oracle = new DrandOracle{salt: SALT}();
        console.log("DrandOracle deployed at:", address(oracle));

        vm.stopBroadcast();
    }
}
