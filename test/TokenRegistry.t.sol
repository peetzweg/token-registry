// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";
import "forge-std/Test.sol";

import {TokenRegistry, TokenInfo} from "../src/TokenRegistry.sol";

contract TokenRegistryTest is Test {
    TokenRegistry tokenRegistry;

    function setUp() public {
        tokenRegistry = new TokenRegistry();
    }

    function testSucessOnValidERC20() public {
        (TokenInfo memory result, ) = tokenRegistry.info(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        assertEq(result.symbol, "USDC");
        assertEq(result.decimals, 6);
    }

    function testErrorOnEOA() public {
        (, bool errored) = tokenRegistry.info(0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045);
        assertEq(errored, true);
    }
}
