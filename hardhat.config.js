require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    Arbitrum_Sepolia: {
      url: process.env.RPC_URL,  // 从环境变量获取 RPC URL
      chainId: 421614,           // 使用正确的链 ID
      accounts: [process.env.PRIVATE_KEY], // 使用环境变量存储私钥
    },
  },
  etherscan: {
    apiKey: {
      arbitrumSepolia: process.env.ARBITRUM_API_KEY,  // 确保为 Arbitrum_Sepolia 提供正确的 API 密钥
    },
    
  },
};
