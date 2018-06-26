pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        // TODO: your code here
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        // TODO: your code here
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // TODO: your code here
    }
}
