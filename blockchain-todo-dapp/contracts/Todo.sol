// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Todo {
    struct Task {
        uint256 id;
        string content;
        bool completed;
    }

    mapping(address => Task[]) private userTasks;
    mapping(address => uint256) public taskCount;

    event TaskCreated(uint256 id, string content, bool completed);
    event TaskCompleted(uint256 id, bool completed);
    event TaskDeleted(uint256 id);

    function createTask(string memory _content) public {
        uint256 id = taskCount[msg.sender];
        userTasks[msg.sender].push(Task(id, _content, false));
        taskCount[msg.sender]++;
        emit TaskCreated(id, _content, false);
    }

    function toggleCompleted(uint256 _id) public {
        require(_id < taskCount[msg.sender], "Task does not exist");
        Task storage task = userTasks[msg.sender][_id];
        task.completed = !task.completed;
        emit TaskCompleted(_id, task.completed);
    }

    function deleteTask(uint256 _id) public {
        require(_id < taskCount[msg.sender], "Task does not exist");
        delete userTasks[msg.sender][_id];
        emit TaskDeleted(_id);
    }

    function getTasks() public view returns (Task[] memory) {
        Task[] memory tasks = new Task[](taskCount[msg.sender]);
        for (uint256 i = 0; i < taskCount[msg.sender]; i++) {
            tasks[i] = userTasks[msg.sender][i];
        }
        return tasks;
    }
}