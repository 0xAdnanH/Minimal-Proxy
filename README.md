## Explanation 
This repository contains a project that has already been created and tested in a separate repository. It includes an account that has the potential to be used by a large number of individuals. However, considering the high deployment cost, particularly on congested networks, it is vital to implement solutions such as utilizing a minimal proxy to deploy these accounts for a specific group of people.

The minimal proxy follows the EIP-1167 standard, which defines a specific bytecode that delegates all calls to a hardcoded address within the bytecode. This design makes the minimal proxy non-upgradeable.

One crucial security concern to be mindful of is the initialization of proxies. If proxies are left uninitialized, it could result in takeovers and malicious activities. To prevent front-running the second initialization transaction when performed separately, it is essential to initialize the proxies in the same transaction. Hence, in this project, a factory is employed to create a clone and initialize it within the same transaction.

Regarding the primary account intended for cloning, I have disabled its initialization since it will solely serve as a reference and should not be controlled by any entity.

## Compiling 
npx hardhat compile
## Testing
npx hardhat test
## Contract Size
The project contain the hardhat contract sizer plugin, to check contract size:

npx hardhat size-contracts

