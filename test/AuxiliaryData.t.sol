// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {DSTestPlus} from "solmate/test/utils/DSTestPlus.sol";
import "forge-std/Test.sol";
import {TokenRegistry, AuxiliaryData} from "../src/TokenRegistry.sol";
import {ERC20Mock} from "../src/mocks/ERC20Mock.sol";
import {ERC20OwnedMock} from "../src/mocks/ERC20OwnedMock.sol";

contract AuxiliaryDataTest is Test {
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
        tokenRegistry.updateAuxiliaryData(address(erc20OwnedMock), AuxiliaryData("IconURL"));
        (AuxiliaryData memory result, bool errored) = tokenRegistry.auxiliaryData(address(erc20OwnedMock));
        assertEq(errored, false);
        assertEq(result.icon, "IconURL");
    }

    function testInfoMultipleTokens() public {
        address[] memory tokens = new address[](2);
        tokens[0] = address(erc20Mock);
        tokens[1] = address(erc20OwnedMock);

        (AuxiliaryData[] memory results, bool[] memory errored) = tokenRegistry.auxiliaryData(tokens);
        assertEq(errored[0], false);
        assertEq(results[0].icon, "");

        assertEq(errored[1], false);
        assertEq(results[1].icon, "");
    }

    function testErrorOnEOA() public {
        (, bool errored) = tokenRegistry.metaData(owner);
        assertEq(errored, true);
    }
}
