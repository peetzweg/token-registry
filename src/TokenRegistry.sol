// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "solmate/tokens/ERC20.sol";

struct TokenInfo {
    string symbol;
    uint8 decimals;
    string name;
}

struct TokenAuxiliaryyInfo {
    string logo;
}

contract TokenRegistry {
    function readTokenInfo(address token) external view returns (TokenInfo memory) {
        ERC20 _token = ERC20(token);
        string memory _name;

        // Try to get name as it's an optional ERC20 field
        try _token.name() returns (string memory name) {
            _name = name;
        } catch {}

        TokenInfo memory _tokenInfo = TokenInfo(_token.symbol(), _token.decimals(), _name);
        return (_tokenInfo);
    }

    function info(address token) external view returns (TokenInfo memory, bool) {
        TokenInfo memory _tokenInfo;
        bool _errored = false;

        // Try as provided address might not be a ERC20 token
        try this.readTokenInfo(token) returns (TokenInfo memory tokenInfo) {
            _tokenInfo = tokenInfo;
        } catch {
            _errored = true;
        }

        return (_tokenInfo, _errored);
    }

    function info(address[] memory tokens) external view returns (TokenInfo[] memory, bool[] memory) {
        TokenInfo[] memory _tokenInfos = new TokenInfo[](tokens.length);
        bool[] memory _errored = new bool[](tokens.length);

        for (uint256 i = 0; i < tokens.length; i++) {
            (TokenInfo memory tokenInfo, bool errored) = this.info(tokens[i]);
            _tokenInfos[i] = tokenInfo;
            _errored[i] = errored;
        }

        return (_tokenInfos, _errored);
    }
}
