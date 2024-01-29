// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address payable recipient;
        uint approvalCount;
        mapping (address => bool) approvals;
        bool complete;
    }

    Request[] public requests;
    address public manager;
    uint public minContribution;
    mapping (address => bool) public approveAddresses;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(uint min, address creator) {
        manager = creator;
        minContribution = min;
    }

    function contribute() public payable {
        require(msg.value > minContribution);
        approveAddresses[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string memory description, uint value, address payable recipient) public restricted {
       Request storage request = requests.push();
       request.description = description;
       request.value = value;
       request.recipient = recipient;
       request.approvalCount = 0;
       request.complete = false;
    }

    function approveRequest(uint id) public {
       Request storage request = requests[id];

       require(approveAddresses[msg.sender]);
       require(!request.approvals[msg.sender]);
       
       request.approvals[msg.sender] = true;
       request.approvalCount++;
    }

    function finalizeRequest(uint id) public restricted {
        Request storage request = requests[id];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        request.recipient.transfer(request.value);
        request.complete = true;
    }
}