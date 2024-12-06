// SPDX-License-Identifier: MIT
const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

// 硬编码 Oracle 地址
const oracleAddress = "0x6Af30863eF0D9cd1faA92ba6c5bfC382d5759481";

module.exports = buildModule("SmartLockModule", (m) => {
  // 部署 SmartLock 合约
  const smartLock = m.contract("SmartLock", [oracleAddress]);

  return { smartLock };
});
