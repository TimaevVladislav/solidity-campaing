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
       Request memory request = Request({
        description: description,
        value: value,
        recipient: recipient,
        approvals: "",
        approvalCount: 0,
        complete: false
       });

       requests.push(request);
    }

    function approveRequest(uint index) public {
       require(approveAddresses[msg.sender]);
       require(!requests[index].approvals[msg.sender]);
    }
}