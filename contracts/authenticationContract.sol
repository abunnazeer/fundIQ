// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract AuthenticationContract {
    mapping(address => bool) private registerUsers; // Mapping of register users

    //Event emitted when a new user is registered
    event UserRegistered(address indexed user);

    //Function to register a new user
    function registerUser() external {
        require(!registerUsers[msg.sender], "User already registered");
        registerUsers[msg.sender] = true;
        emit UserRegistered(msg.sender);
    }

    // Function to authenticate a user
    function authenticateUser() external view returns (bool) {
        return registerUsers[msg.sender];
    }
}
