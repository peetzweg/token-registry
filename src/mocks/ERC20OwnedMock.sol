// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "solmate/tokens/ERC20.sol";
import "solmate/auth/Owned.sol";

contract ERC20OwnedMock is ERC20, Owned {
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address owner_
    ) ERC20(name_, symbol_, decimals_) Owned(owner_) {}
}
