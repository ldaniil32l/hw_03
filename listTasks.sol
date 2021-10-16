pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract listTasks {
    uint32 public timestamp;

    struct task {
        string caseName;
        uint32 timeAdd;
        bool done;
    }

    // array with remote task keys
    int8[] public numDelTasks;
    // number of tasks
    int8 public countTask = 0;

    mapping(int8 => task) public lstTasks;

	constructor() public {
		require(tvm.pubkey() != 0, 101);
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
        timestamp = now;
	}

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    // adding a task
	function addTask(string value) public checkOwnerAndAccept {
        require(value != '', 104);
        task oneTask = task(value, now, false);
        countTask++;
        lstTasks.add(countTask, oneTask);
    }

    // number of open tasks
    function countOpenTask() public returns(int8 memory) {
        require(msg.pubkey() == tvm.pubkey(), 102);
        require(countTask != 0, 103);
        int8 openTask = 0;
        for(int8 i = 1; i <= countTask; i++){
            if (!lstTasks[i].done){
                openTask++;
            }
        }
		tvm.accept();
        return openTask;
    }

    // return the list of tasks in the line
    function returnListTask() public returns(string[] memory)  {
        require(msg.pubkey() == tvm.pubkey(), 102);
        require(countTask != 0, 103);
        string[] casec;
        for(uint i = 1; i < uint(countTask); i++){
            casec.push(lstTasks[int8(i)].caseName);
        }
        casec.push(lstTasks[countTask].caseName);
		tvm.accept();
        return casec;
    }

    // get a task by key
    function getTask(int8 value) public returns(task memory) {
        require(msg.pubkey() == tvm.pubkey(), 102);
        require(countTask != 0, 103);
        require(countTask >= value, 104);
        for(uint i; i < numDelTasks.length; i++){
            require(value != numDelTasks[i], 105);
        }
		tvm.accept();
        return lstTasks[value];
    }
    // delete a task by key
    function delTask(int8 value) public checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        require(countTask != 0, 103);
        require(countTask >= value, 104);
        for(uint i; i < numDelTasks.length; i++){
            require(value != numDelTasks[i], 105);
        }
        delete lstTasks[value];
        numDelTasks.push(value);
		tvm.accept();
    }
    // marking a task as completed
    function checkTask(int8 value) public checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        require(countTask != 0, 103);
        require(countTask >= value, 104);
        for(uint i; i < numDelTasks.length; i++){
            require(value != numDelTasks[i], 105);
        }
        lstTasks[value].done = true;
		tvm.accept();
    }
}
