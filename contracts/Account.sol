// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @title Account
 * @dev A smart contract that provides functionalities for interacting with ERC20 tokens and ERC721 non-fungible tokens (NFTs).
 */
contract Account is Initializable, ERC165, OwnableUpgradeable {
    receive() external payable {}

    /**
     * @dev Emitted when a call to an external contract succeeds.
     */
    event CallSucceeded();

    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Initializes the contract.
     */
    function initialize() public initializer {
        __Ownable_init();
    }

    /**
     * @dev Makes a call to an external contract and sends Ether along with the call.
     * Only the contract owner can invoke this function.
     * @param _recipient The address of the recipient contract.
     * @param valueTosend The amount of Ether to send with the call.
     * @param dataTosend The data to include in the call.
     * @return The result of the call.
     */
    function callandSend(
        address _recipient,
        uint256 valueTosend,
        bytes memory dataTosend
    ) public payable onlyOwner returns (bytes memory) {
        (bool success, bytes memory returnData) = _recipient.call{
            value: valueTosend
        }(dataTosend);
        emit CallSucceeded();
        return Address.verifyCallResult(success, returnData, "Call failed");
    }

    /**
     * @dev Sends ERC20 tokens to a specified address.
     * Only the contract owner can invoke this function.
     * @param tokenAddress The address of the ERC20 token contract.
     * @param to The address of the recipient.
     * @param amount The amount of tokens to send.
     */
    function sendERC20(
        address tokenAddress,
        address to,
        uint256 amount
    ) public onlyOwner {
        IERC20(tokenAddress).transfer(to, amount);
        emit CallSucceeded();
    }

    /**
     * @dev Transfers ERC721 tokens from one address to another.
     * Only the contract owner can invoke this function.
     * @param NFTaddress The address of the ERC721 token contract.
     * @param from The address of the current owner.
     * @param to The address of the recipient.
     * @param tokenId The ID of the token to transfer.
     */
    function sendERC721(
        address NFTaddress,
        address from,
        address to,
        uint256 tokenId
    ) public onlyOwner {
        IERC721(NFTaddress).transferFrom(from, to, tokenId);
        emit CallSucceeded();
    }

    /**
     * @dev Receives ERC721 tokens. Returns the magic value of the ERC721 receiver interface.
     * @param operator The address that called the function.
     * @param from The address from which the token is transferred.
     * @param tokenId The ID of the token being transferred.
     * @param data Additional data with no specified format.
     * @return The magic value `onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    /**
     * @dev Validates the provided signature by recovering the signer's address.
     * @param _hash The message hash that was signed.
     * @param _signature The provided signature.
     * @return The magic value `0x1626ba7e` if the signature is valid and matches the contract owner's address.
     * Otherwise, it returns `0xffffffff`.
     */
    function isValidSignature(
        bytes32 _hash,
        bytes memory _signature
    ) public view returns (bytes4 magicValue) {
        address recovered = ECDSA.recover(_hash, _signature);
        if (recovered == owner()) {
            return 0x1626ba7e;
        } else {
            return 0xffffffff;
        }
    }

    /**
     * @dev Checks if the contract supports a given interface.
     * @param interfaceId The interface identifier.
     * @return True if the contract supports the interface, false otherwise.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == 0x1626ba7e ||
            interfaceId == IERC721Receiver.onERC721Received.selector;
    }
}
