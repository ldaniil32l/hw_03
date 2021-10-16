
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract queue {
	// array of strings
    string[] public queueStr;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);

		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

	// adding a person to the queue
    function pushQueue(string name) public checkOwnerAndAccept{
		require(name != "", 103);
        queueStr.push(name);

	}

	// removing the first person from the queue
	function deleteFirst() public checkOwnerAndAccept{
        require(queueStr.length != 0, 104);
        for (uint i = 0; i < queueStr.length-1; i++){
            queueStr[i] = queueStr[i+1];
        }
		queueStr.pop();
    }
}
