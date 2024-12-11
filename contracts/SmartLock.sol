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

    mapping(address => bool) public managers; // 管理者列表

    // 事件：锁定事件
    event Locked();
    // 事件：解锁事件
    event Unlocked(address indexed user);
    // 事件：合约所有者变更
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    // 事件：管理者添加
    event ManagerAdded(address indexed manager);
    // 事件：管理者移除
    event ManagerRemoved(address indexed manager);

    // 权限控制：只有合约所有者才能操作
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 权限控制：只有合约所有者或管理者才能操作
    modifier onlyOwnerOrManager() {
        require(msg.sender == owner || managers[msg.sender], "Not authorized");
        _;
    }

    // 构造函数：初始化合约并指定预言机合约地址
    constructor(address _oracleAddress) {
        identityOracle = IIdentityOracle(_oracleAddress);
        owner = msg.sender;
        isLocked = true;  // 初始状态为锁定
    }

    // 设置门锁的状态为锁定
    function lock(address user) public {
        require(
            msg.sender == owner || managers[msg.sender] || identityOracle.getUserIdentity(user),
            "Not authorized to lock"
        );
        isLocked = true;
        emit Locked();
    }

    // 解锁门锁，允许用户自己、管理员或owner解锁
    function unlock(address user) public {
        // 如果是合约所有者或管理员，允许解锁
        if (msg.sender == owner || managers[msg.sender]) {
            isLocked = false;
            userUnlockTimes[user] = block.timestamp;  // 记录用户解锁的时间戳
            emit Unlocked(user);
            return;
        }

        // 如果是用户本人，检查预言机验证
        require(identityOracle.getUserIdentity(user), "User not verified");
        
        uint256 verificationTime = identityOracle.getIdentityTimestamp(user);
        // 验证时间是否在超时时间内
        require(block.timestamp - verificationTime <= lockTimeout, "Verification expired");
        
        isLocked = false;
        userUnlockTimes[user] = block.timestamp;  // 记录用户解锁的时间戳
        emit Unlocked(user);
    }

    // 添加管理者
    function addManager(address manager) public onlyOwner {
        require(manager != address(0), "Invalid address");
        managers[manager] = true;
        emit ManagerAdded(manager);
    }

    // 移除管理者
    function removeManager(address manager) public onlyOwner {
        require(managers[manager], "Not a manager");
        managers[manager] = false;
        emit ManagerRemoved(manager);
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
    function setLockTimeout(uint256 timeout) external onlyOwnerOrManager {
        lockTimeout = timeout;
    }
}
