// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";
import "forge-std/Test.sol";
import {TokenRegistry, MetaData} from "../src/TokenRegistry.sol";
import {ERC20Mock} from "../src/mocks/ERC20Mock.sol";
import {ERC20OwnedMock} from "../src/mocks/ERC20OwnedMock.sol";

contract MetaDataTest is Test {
    TokenRegistry tokenRegistry;

    address owner = address(0x1);

    ERC20Mock erc20Mock;
    ERC20OwnedMock erc20OwnedMock;

    function setUp() public {
        tokenRegistry = new TokenRegistry();
        erc20Mock = new ERC20Mock("ERC20Mock", "ERC20", 6);
        erc20OwnedMock = new ERC20OwnedMock("ERC20OwnedMock", "ERC20Owned", 6, owner);
    }

    function testInfoSingleToken() public {
        (MetaData memory result, bool errored) = tokenRegistry.metaData(address(erc20Mock));
        assertEq(errored, false);
        assertEq(result.name, "ERC20Mock");
        assertEq(result.symbol, "ERC20");
        assertEq(result.decimals, 6);
    }

    function testInfoMultipleTokens() public {
        address[] memory tokens = new address[](2);
        tokens[0] = address(erc20Mock);
        tokens[1] = address(erc20OwnedMock);

        (MetaData[] memory results, bool[] memory errored) = tokenRegistry.metaData(tokens);
        assertEq(errored[0], false);
        assertEq(results[0].name, "ERC20Mock");
        assertEq(results[0].symbol, "ERC20");
        assertEq(results[0].decimals, 6);

        assertEq(errored[1], false);
        assertEq(results[1].name, "ERC20OwnedMock");
        assertEq(results[1].symbol, "ERC20Owned");
        assertEq(results[1].decimals, 6);
    }

    function testErrorOnEOA() public {
        (, bool errored) = tokenRegistry.metaData(owner);
        assertEq(errored, true);
    }
}
