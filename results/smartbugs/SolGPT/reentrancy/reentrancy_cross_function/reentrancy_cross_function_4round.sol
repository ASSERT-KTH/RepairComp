pragma solidity ^0.4.24;

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function transfer(address to, uint amount) {
        require(userBalances[msg.sender] >= amount);
        
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        
        msg.sender.transfer(amountToWithdraw);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
}