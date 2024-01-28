// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        uint approvalCount;
        mapping (address => bool) approvals;
        bool complete;
    }

    Request[] public requests;
    address public manager;
    uint public minContribution;
    mapping (address => bool) public approveAddresses;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(uint min) {
        manager = msg.sender;
        minContribution = min;
    }

    function contribute() public payable {
        require(msg.value > minContribution);
        approveAddresses[msg.sender] = true;
    }

    function createRequest(string memory description, uint value, address recipient) public restricted {
       Request storage request = requests.push();
       request.description = description;
       request.value = value;
       request.recipient = recipient;
       request.approvalCount = 0;
       request.complete = false;
    }

    function approveRequest(uint index) public {
       Request storage request = requests[index];

       require(approveAddresses[msg.sender]);
       require(!request.approvals[msg.sender]);
       
       request.approvals[msg.sender] = true;
       request.approvalCount++;
    }
}