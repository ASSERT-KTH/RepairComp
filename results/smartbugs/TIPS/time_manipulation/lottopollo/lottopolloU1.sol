contract lottopollo {
	address leader;
	uint timestamp;
	function payOut(uint rand) internal {
	if(rand > 0 && now - rand > 24 hours){
	if(! msg.sender.send(msg.value)){
	throw;}
	if(this.balance > 0){
	if(! leader.send(this.balance)){
	throw;}
	}
	}
	else{
	if(msg.value >= 1 ether){
	leader = msg.sender;
	timestamp = rand;
	}
	}
	}
	function randomGen() view public returns(uint randomNumber){
	return block.timestamp;
	}
	function draw(uint seed) public {
	uint randomNumber = randomGen();
	payOut(randomNumber);
	}
	
}