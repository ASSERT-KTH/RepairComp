contract DosNumber {
	uint numElements = 0;
	uint[] array;
	function insertNnumbers(uint value, uint numbers) public {
	for(uint i = 0;i < numbers;i++){
	if(numElements == array.length){
	array.length += 1;
	}
	array[numElements++] = value;
	}
	}
	function clear() public {
	require(numElements > 1500);
	numElements = 0;
	}
	function clearDOS() public {
	require(numElements > 1500);
	array = new uint[](0);
	numElements = 0;
	}
	function getLengthArray() view public returns(uint ){
	return numElements;
	}
	function getRealLengthArray() view public returns(uint ){
	return array.length;
	}
	
}