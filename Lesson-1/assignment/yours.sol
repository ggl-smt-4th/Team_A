pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 0 ether;
    address employee = 0x0;
    uint payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        // salary is not set
        if (salary == 0) {
            revert();
        }
        
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        // employee is not set
        if (employee == 0x0) {
            revert();
        }
        
        // sender is not the employee
        if (msg.sender != employee) {
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
    
    function setEmployee(address e) {
        // transfer remaining salary
        uint previousRemaining = ((now - lastPayday) / payDuration) * salary;
        address previousEmployee = employee;
        
        employee = e;
        lastPayday = now;
        
        if (this.balance < previousRemaining) {
            revert();
        }
        previousEmployee.transfer(previousRemaining);
    }
    
    function setSalary(uint s) {
        salary = s;
    }
}