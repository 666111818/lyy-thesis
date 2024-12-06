// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentityOracle {
    // 存储用户的身份状态
    mapping(address => bool) private identities;
    // 存储用户身份验证的时间戳
    mapping(address => uint256) private identityTimestamps;

    address public owner;
    uint256 public verificationTimeout = 300; // 5分钟验证超时

    // 事件：身份更新
    event IdentityUpdated(address indexed user, bool status, uint256 timestamp);
    // 事件：合约所有者变更
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // 权限控制：只有合约所有者能操作
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 构造函数：初始化所有者
    constructor() {
        owner = msg.sender;
    }

    // 设置用户的身份状态（由所有者操作）
    function updateIdentity(address user, bool status) external onlyOwner {
        identities[user] = status;
        identityTimestamps[user] = block.timestamp;
        emit IdentityUpdated(user, status, block.timestamp);
    }

    // 获取用户的身份状态
    function getUserIdentity(address user) external view returns (bool) {
        return identities[user];
    }

    // 获取用户的身份验证时间戳
    function getIdentityTimestamp(address user) external view returns (uint256) {
        return identityTimestamps[user];
    }

    // 设置身份验证的超时时间（单位：秒）
    function setVerificationTimeout(uint256 timeout) external onlyOwner {
        verificationTimeout = timeout;
    }

    // 合约所有者转移
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
