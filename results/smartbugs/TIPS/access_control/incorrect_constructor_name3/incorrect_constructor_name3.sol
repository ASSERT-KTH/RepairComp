contract Missing {
	address private owner;
	modifier onlyowner(){
	require(msg.sender == owner);
	_;}
	function Constructor() public {
	owner = msg.sender;
	}
	function () payable public {
	}
	function withdraw() onlyowner public {
	owner.transfer(this.balance);
	}
	
}