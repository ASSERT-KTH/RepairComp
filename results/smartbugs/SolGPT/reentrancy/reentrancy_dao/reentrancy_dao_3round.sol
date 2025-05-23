pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping (address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0);
        
        credit[msg.sender] = 0; // Update credit before making external call
        balance -= oCredit;

        bool callResult = msg.sender.call.value(oCredit)();
        require(callResult);
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}