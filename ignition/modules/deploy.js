// SPDX-License-Identifier: MIT
const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("IdentityOracleModule", (m) => {
  // 获取合约部署者的地址作为 owner
  const owner = m.getParameter("owner", m.deployingAccount);

  // 部署 IdentityOracle 合约（不需要构造参数，直接部署）
  const identityOracle = m.contract("IdentityOracle", []);

  return { identityOracle };
});
