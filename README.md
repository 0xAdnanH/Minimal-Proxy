# Minimal Proxy 

The Minimal Proxy project focuses on deploying proxies according to the [EIP-1167](https://eips.ethereum.org/EIPS/eip-1167) standard for account contracts. The repository includes an already created and tested account contract in the [Account-Contract](https://github.com/0xAdnanH/Account-Contract) repository.

## Goals of the Project

The project's primary objectives are to:

- **Utilize Minimal Proxies for Deployment Efficiency:** Highlight the use of Minimal Proxies when deploying account contracts that are expected to be used multiple times. Instead of deploying the full code repeatedly, Minimal Proxies provide a cost-effective solution by referencing the implementation contract.

- **Address Security Measures for Minimal Proxy Deployment:** While deploying normal contracts can involve using factories, deploying Minimal Proxies requires careful consideration. They should be initialized within the same transaction. To achieve this, the project employs a factory that initializes in the same transaction, in contrast to the typical factory approach that is done in the [Factory](https://github.com/0xAdnanH/Factory) repository.

## Technicalities of the Project

- **Usage of Clones Library from OpenZeppelin:** The project leverages the Clones library from OpenZeppelin to facilitate the deployment of EIP-1167 proxies. This streamlined approach simplifies the creation of proxies while adhering to the EIP-1167 standard.

- **Balanced Cost Considerations:** Deploying Minimal Proxies offers a low deployment cost compared to deploying full contracts multiple times. However, it is essential to note that the execution (runtime) cost is slightly higher due to the delegate call associated with forwarding the call to the implementation contract.

- **Disable Initialization for Implementation:** The implementation contract that will solely serve as a reference and should not be controlled by any entity, hence initialization is locked by default deployment.

- **Use of Hardhat Plugin to detect contract size:** [hardhat-contract-sizer](https://github.com/ItsNickBarry/hardhat-contract-sizer) hardhat plugin was used to detect contract size. Command can be found in Instructions section.

- **Documentation Using Natspec:** The project's functions and overall functionality are comprehensively documented using Natspec, providing clear insights into the purpose and usage of each component.

- **Unit Tests with ethers.js:** The project features unit tests written using `ethers.js` to ensure the proper functionality of the deployed proxies. These tests enhance the reliability and robustness of the codebase.

**Note:** The Minimal Proxy Deployer project aims to demonstrate the advantages of using Minimal Proxies for efficient contract deployment. It is designed for educational purposes and provides insights into cost optimization and security considerations.

## Installation

### Cloning the Repository

You can clone the repository and install its dependencies to start using the provided smart contracts.

```bash
$ git clone https://github.com/0xAdnanH/Minimal-Proxy.git
$ cd ./Minimal-Proxy
$ npm install
```

### Instructions

#### Compile

To Compile the contract run:

```bash
$ npx hardhat compile
```

#### Tests

To run the unit tests:

```bash
$ npx hardhat test
```

#### Contract Size

The project contain the hardhat contract sizer plugin, to check contract size:

```bash
npx hardhat size-contracts
```

