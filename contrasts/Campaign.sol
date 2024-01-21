
pragma solidity ^0.8.9;

contract Campaign {
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
    }

    address public manager;
    uint public minContribution;
    address[] public approveAddresses;

    constructor(uint min) {
        manager = msg.sender;
        minContribution = min;
    }

    function contribute() public payable {
        require(msg.value > minContribution);
        approveAddresses.push(msg.sender);
    }
}