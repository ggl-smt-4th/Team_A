pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 30 days;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;

    constructor() public {
        owner = msg.sender;
    }

    function updateEmployeeAddress(address e) public {
        // Sender should be the owner
        require(msg.sender == owner);

        // Check if addresses are the same
        require(e != employee);

        if (employee != 0x0) {
            // Pay salary before change an existing employee
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        // Update employee
        employee = e;
        salary = 1 ether; // Default salary
        lastPayday = now;
    }

    function updateEmployeeSalary(uint s) public {
        // Sender should be the owner
        require(msg.sender == owner);

        // Check salary range
        require(s > 0);

        if (employee != 0x0) {
            // Pay salary before change an existing employee
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }

        // Update salary
        salary = s * 1 ether;
        lastPayday = now;
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() view public returns (uint) {
        return address(this).balance / salary;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        // Sender should be the employee
        require(msg.sender == employee);

        // 0. Original version
        // Check payday information
        // uint nextPayday = lastPayday + payDuration;
        // require(nextPayday < now);

        // Update payday information
        // lastPayday = nextPayday;

        // Transfer salary
        // employee.transfer(salary);

        // 1. Updated version
        // Check number of pay durations
        uint numPayCycle = (now - lastPayday) / payDuration;
        require(numPayCycle >= 1); // At least one duration

        // Update payday information
        lastPayday += numPayCycle * payDuration;

        // transfer salary
        employee.transfer(salary * numPayCycle);
    }
}
