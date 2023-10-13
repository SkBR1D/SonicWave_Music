// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SonicWaveMusicSignUp {
    address public owner;
    uint256 public signUpFee;
    mapping(address => bool) public hasPaid;

    event AccountCreated(address indexed user, uint256 fee);

    constructor(uint256 _fee) {
        owner = msg.sender;
        signUpFee = _fee; // Set the one-time signup fee
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to change the signup fee, callable only by the owner
    function setSignUpFee(uint256 _newFee) public onlyOwner {
        signUpFee = _newFee;
    }

    // Function for users to sign up by paying the fee
    function signUp() public payable {
        require(msg.value >= signUpFee, "Insufficient payment to sign up");
        require(!hasPaid[msg.sender], "User has already signed up");

        hasPaid[msg.sender] = true;
        emit AccountCreated(msg.sender, signUpFee);
    }

    // Function to check if a user has signed up
    function hasSignedUp(address _user) public view returns (bool) {
        return hasPaid[_user];
    }

    // Function for the owner to withdraw funds
    function withdrawFunds() public onlyOwner {
        require(address(this).balance > 0, "No funds available for withdrawal");
        payable(owner).transfer(address(this).balance);
    }
}

