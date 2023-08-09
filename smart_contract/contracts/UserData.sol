// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract UserData{
    event AccountCreated(address userID, string userName, bytes32 userPassword, string vehicleNumber, string licenseNumber, uint256 mobileNumber);
    struct UserStruct{
        address MetaMaskId;
        string name;
        bytes32 password;
        string VehicleNumber;
        // string registrationNumber;
        string licenseNumber;
        uint256 mobile;
    }

    UserStruct[] users;

    function addToBlockchain(string memory name, bytes memory password, string memory vehicle, string memory license, uint256 number) public {
        users.push(UserStruct(msg.sender, name, sha256(password), vehicle, license, number));

        emit AccountCreated(msg.sender, name, sha256(password), vehicle, license, number);
    }

    function getData() public view returns (UserStruct[] memory){
        return users;
    }
}