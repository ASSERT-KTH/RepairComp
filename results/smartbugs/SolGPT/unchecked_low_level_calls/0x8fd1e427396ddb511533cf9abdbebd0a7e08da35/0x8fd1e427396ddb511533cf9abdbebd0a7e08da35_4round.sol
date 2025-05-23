pragma solidity ^0.4.18;

contract Ownable {
    address public owner;
    address public newOwner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function WithdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping (address => uint) public Holders;

    function initTokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() public payable {
        Deposit();
    }

    function Deposit() public payable {
        if(msg.value >= MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WithdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(Holders[_to] > 0);
        Holders[_to] = 0;
        WithdrawToken(_token, _amount, _to);
    }

    function WithdrawToHolder(address _addr, uint _wei) public onlyOwner payable {
        require(Holders[_addr] >= _wei);
        _addr.transfer(_wei);
        Holders[_addr] -= _wei;
    }

    function Bal() public view returns(uint) {
        return this.balance;
    }
}