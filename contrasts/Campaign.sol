// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
    }

    Request[] public requests;
    address public manager;
    uint public minContribution;
    address[] public approveAddresses;

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
        approveAddresses.push(msg.sender);
    }

    function createRequest(string memory description, uint value, address recipient) public restricted {
       Request memory request = Request({
        description: description,
        value: value,
        recipient: recipient,
        complete: false
       });

       requests.push(request);
    }
}