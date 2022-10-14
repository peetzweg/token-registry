// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";
import {TokenRegistry, AuxiliaryData, TokenInfo} from "../src/TokenRegistry.sol";
import {ERC20Mock} from "../src/mocks/ERC20Mock.sol";
import {ERC20OwnedMock} from "../src/mocks/ERC20OwnedMock.sol";

contract TokenInfoTest is Test {
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
        vm.prank(owner);
        tokenRegistry.updateAuxiliaryData(address(erc20OwnedMock), AuxiliaryData("mockIconURL"));

        (TokenInfo memory result, bool errored) = tokenRegistry.info(address(erc20OwnedMock));
        assertEq(errored, false);
        assertEq(result.meta.name, erc20OwnedMock.name());
        assertEq(result.meta.symbol, erc20OwnedMock.symbol());
        assertEq(result.meta.decimals, erc20OwnedMock.decimals());
        assertEq(result.auxiliary.icon, "mockIconURL");
    }

    function testInfoMultipleTokens() public {
        address[] memory tokens = new address[](2);
        tokens[0] = address(erc20Mock);
        tokens[1] = address(erc20OwnedMock);

        vm.prank(owner);
        tokenRegistry.updateAuxiliaryData(address(erc20OwnedMock), AuxiliaryData("mockIconURL"));

        (TokenInfo[] memory results, bool[] memory errored) = tokenRegistry.info(tokens);
        assertEq(errored[0], false);
        assertEq(results[0].meta.name, erc20Mock.name());
        assertEq(results[0].meta.symbol, erc20Mock.symbol());
        assertEq(results[0].meta.decimals, erc20Mock.decimals());
        assertEq(results[0].auxiliary.icon, "");

        assertEq(errored[1], false);
        assertEq(results[1].meta.name, erc20OwnedMock.name());
        assertEq(results[1].meta.symbol, erc20OwnedMock.symbol());
        assertEq(results[1].meta.decimals, erc20OwnedMock.decimals());
        assertEq(results[1].auxiliary.icon, "mockIconURL");
    }

    function testErrorOnEOA() public {
        (, bool errored) = tokenRegistry.metaData(owner);
        assertEq(errored, true);
    }
}
