// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IIdentityOracle {
    function getUserIdentity(address user) external view returns (bool);
    function getIdentityTimestamp(address user) external view returns (uint256);
}

contract SmartLock {
    IIdentityOracle public identityOracle;  // 预言机合约地址
    address public owner;  // 合约所有者
    bool public isLocked;  // 门锁的状态

    uint256 public lockTimeout = 300;  // 5分钟门锁超时
    mapping(address => uint256) private userUnlockTimes;  // 用户解锁的时间戳

    // 事件：锁定事件
    event Locked();
    // 事件：解锁事件
    event Unlocked(address indexed user);
    // 事件：合约所有者变更
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // 权限控制：只有合约所有者才能操作
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 构造函数：初始化合约并指定预言机合约地址
    constructor(address _oracleAddress) {
        identityOracle = IIdentityOracle(_oracleAddress);
        owner = msg.sender;
        isLocked = true;  // 初始状态为锁定
    }

    // 设置门锁的状态为锁定
    function lock() public onlyOwner {
        isLocked = true;
        emit Locked();
    }

    // 解锁门锁，只有验证通过的用户才能解锁
    function unlock(address user) public {
        require(identityOracle.getUserIdentity(user), "User not verified");
        
        uint256 verificationTime = identityOracle.getIdentityTimestamp(user);
        // 验证时间是否在超时时间内
        require(block.timestamp - verificationTime <= lockTimeout, "Verification expired");
        
        isLocked = false;
        userUnlockTimes[user] = block.timestamp;  // 记录用户解锁的时间戳
        emit Unlocked(user);
    }

    // 获取门锁的当前状态
    function getLockStatus() public view returns (bool) {
        return isLocked;
    }

    // 获取用户最后解锁的时间
    function getUserUnlockTime(address user) public view returns (uint256) {
        return userUnlockTimes[user];
    }

    // 合约所有者转移
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // 设置门锁超时时间（单位：秒）
    function setLockTimeout(uint256 timeout) external onlyOwner {
        lockTimeout = timeout;
    }
}
