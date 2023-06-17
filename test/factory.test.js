const { expect } = require("chai");
const { ethers } = require("hardhat");

let factoryContract;
let accountContract;
let addr1;
let addr2;
let addr3;
before(async () => {
  [addr1, addr2, addr3] = await ethers.getSigners();
  const getfactory = await ethers.getContractFactory("factory");
  const accFactory = await ethers.getContractFactory("Account");
  factoryContract = await getfactory.deploy();
  accountContract = await accFactory.deploy();
});

describe("Proxy Test", () => {
  it("should create a proxy and initialize", async () => {
    const initializeSelector =
      await accountContract.interface.encodeFunctionData("initialize");

    const proxyAddress = await factoryContract.minimalProxy.staticCall(
      initializeSelector,
      accountContract,
      0
    );

    expect(
      await factoryContract.minimalProxy(initializeSelector, accountContract, 0)
    ).to.emit(factoryContract, "ProxyCreated");
  });
});
