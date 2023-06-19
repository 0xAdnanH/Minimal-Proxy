// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract factory {
    event ProxyCreated();

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
