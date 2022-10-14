// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
import "solmate/tokens/ERC20.sol";
import "solmate/auth/Owned.sol";

struct MetaData {
    string symbol;
    uint8 decimals;
    string name;
}

struct AuxiliaryData {
    string icon;
}

struct Data {
    MetaData meta;
    AuxiliaryData auxiliary;
}

contract TokenRegistry {
    event AuxiliaryDataUpdated(address indexed token, AuxiliaryData indexed data);

    mapping(address => AuxiliaryData) public _auxiliaryData;

    function updateAuxiliaryData(address token, AuxiliaryData memory newAuxiliaryData) external returns (bool) {
        require(msg.sender == Owned(token).owner(), "UNAUTHORIZED");

        _auxiliaryData[token] = newAuxiliaryData;

        emit AuxiliaryDataUpdated(token, newAuxiliaryData);

        return true;
    }

    function metaData(address token) external view returns (MetaData memory, bool) {
        MetaData memory returnMetaData;
        bool returnErrored = false;

        // Try as provided address might not be a ERC20 token
        try this._readMetaData(token) returns (MetaData memory readMetaData) {
            returnMetaData = readMetaData;
        } catch {
            returnErrored = true;
        }

        return (returnMetaData, returnErrored);
    }

    function metaData(address[] memory tokens) external view returns (MetaData[] memory, bool[] memory) {
        MetaData[] memory returnMetaData = new MetaData[](tokens.length);
        bool[] memory returnErrored = new bool[](tokens.length);

        for (uint256 i = 0; i < tokens.length; i++) {
            (MetaData memory readMetaData, bool errored) = this.metaData(tokens[i]);
            returnMetaData[i] = readMetaData;
            returnErrored[i] = errored;
        }

        return (returnMetaData, returnErrored);
    }

    function _readMetaData(address token) external view returns (MetaData memory) {
        ERC20 _token = ERC20(token);
        string memory _name;

        // Try to get name as it's an optional ERC20 field
        try _token.name() returns (string memory name) {
            _name = name;
        } catch {}

        MetaData memory _metaData = MetaData(_token.symbol(), _token.decimals(), _name);
        return (_metaData);
    }

    function auxiliaryData(address token) external view returns (AuxiliaryData memory, bool) {
        AuxiliaryData memory resultAuxiliaryData;
        bool returnErrored = false;

        // Try as provided address might not be a ERC20 token
        try this._readAuxiliaryData(token) returns (AuxiliaryData memory readAuxiliaryData) {
            resultAuxiliaryData = readAuxiliaryData;
        } catch {
            returnErrored = true;
        }

        return (resultAuxiliaryData, returnErrored);
    }

    function auxiliaryData(address[] memory tokens) external view returns (AuxiliaryData[] memory, bool[] memory) {
        AuxiliaryData[] memory returnAuxiliaryData = new AuxiliaryData[](tokens.length);
        bool[] memory returnErrored = new bool[](tokens.length);

        for (uint256 i = 0; i < tokens.length; i++) {
            (AuxiliaryData memory readAuxiliaryData, bool errored) = this.auxiliaryData(tokens[i]);
            returnAuxiliaryData[i] = readAuxiliaryData;
            returnErrored[i] = errored;
        }

        return (returnAuxiliaryData, returnErrored);
    }

    function _readAuxiliaryData(address token) external view returns (AuxiliaryData memory) {
        return _auxiliaryData[token];
    }
}
