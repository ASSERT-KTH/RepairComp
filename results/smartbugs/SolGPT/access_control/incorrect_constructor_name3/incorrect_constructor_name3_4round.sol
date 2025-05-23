pragma solidity ^0.4.24;

contract MissingContract {
    address private owner;

    modifier onlyowner {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function () external payable {
    }

    function withdraw() public onlyowner {
        owner.transfer(address(this).balance);
    }
}