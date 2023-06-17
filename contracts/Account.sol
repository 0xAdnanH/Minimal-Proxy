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

contract Account is Initializable, ERC165, OwnableUpgradeable {
    receive() external payable {}

    event CallSucceeded();

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init();
    }

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

    function sendERC20(
        address tokenAddress,
        address to,
        uint256 amount
    ) public onlyOwner {
        IERC20(tokenAddress).transfer(to, amount);
        emit CallSucceeded();
    }

    function sendERC721(
        address NFTaddress,
        address from,
        address to,
        uint256 amount
    ) public onlyOwner {
        IERC721(NFTaddress).transferFrom(from, to, amount);
        emit CallSucceeded();
    }

    function onERC721Received(
        address /*operator*/,
        address /*from*/,
        uint256 /*tokenId*/,
        bytes calldata /*data*/
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

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

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == 0x1626ba7e ||
            interfaceId == IERC721Receiver.onERC721Received.selector;
    }
}
