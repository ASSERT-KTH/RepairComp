pragma solidity ^0.4.24;

contract Reentrancy_bonus{
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    
    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        recipient.transfer(amountToWithdraw);
    }
    
    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); 
        
        rewardsForA[recipient] += 100;
        
        claimedBonus[recipient] = true;
        withdrawReward(recipient); 
    }
}