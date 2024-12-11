# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
 npx hardhat clean  
 npx hardhat compile
npx hardhat ignition deploy ./ignition/modules/IdentityOracleModule.js --network Arbitrum_Sepolia
npx hardhat verify --network Arbitrum_Sepolia 0x6Af30863eF0D9cd1faA92ba6c5bfC382d5759481

npx hardhat ignition deploy ./ignition/modules/SmartLockModule.js --network Arbitrum_Sepolia
npx hardhat verify --network Arbitrum_Sepolia 0xBfaDEF88a8D71D4e9D46Cd30D27489dc22aA51B7 "0x6Af30863eF0D9cd1faA92ba6c5bfC382d5759481"

```
