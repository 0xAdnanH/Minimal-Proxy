// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title Factory
 * @dev A smart contract that facilitates the creation of minimal proxies using the Clones library.
 */
contract Factory {
    /**
     * @dev Emitted when a new proxy is created.
     */
    event ProxyCreated();

    /**
     * @dev Creates a minimal proxy using the Clones library and invokes a function on the created proxy.
     * @param data The data to be executed on the proxy.
     * @param implementation The address of the contract to clone.
     * @param value The value of Ether to send with the call.
     * @return The address of the created proxy.
     */
    function minimalProxy(
        bytes memory data,
        address implementation,
        uint256 value
    ) public payable returns (address) {
        address createdProxy = Clones.clone(implementation);
        (bool success, bytes memory returnData) = createdProxy.call{
            value: value
        }(data);

        Address.verifyCallResult(success, returnData, "Failed");
        emit ProxyCreated();
        return createdProxy;
    }
}
