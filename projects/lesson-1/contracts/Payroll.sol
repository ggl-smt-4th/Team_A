pragma solidity ^0.4.14;

/**
 * @title Payroll
 * @dev A payroll system for single employee.
 */

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 1 hours;
    uint totalEmployee = 1;
    Employee employee;
    
    /** 
     * @dev The constructor sets the contract owner and employee info.
     */
    function Payroll(address _id, uint _salary) {
        employee = Employee(_id, _salary.mul(1 ether), now);
    }

    modifier employeeValid(address employeeId) {
        require(employeeId != 0x0);
        _;
    }
    
    function partialPaid(Employee employeeCurr) private employeeValid(employeeCurr.id) {
        uint payment = employeeCurr.salary
            .mul(now.sub(employeeCurr.lastPayday))
            .div(payDuration);
        employeeCurr.id.transfer(payment);
    }
    
    function updateEmployeeId(address employeeId) onlyOwner employeeValid(employeeId) {
        partialPaid(employee);
        employee.lastPayday = now;
        employee.id = employeeId;
    }
    
    function updateEmployeeSalary(uint salary) onlyOwner {
        partialPaid(employee);
        employee.lastPayday = now;
        employee.salary = salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() constant returns (uint) {
        return this.balance.div(employee.salary);
    }

    function hasEnoughFund() constant returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeValid(msg.sender) {
        require(employee.id == msg.sender);

        uint nextPayday = employee.lastPayday.add(payDuration);
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function checkInfo() constant returns (uint balance, address id, uint salary, uint date) {
        balance = this.balance;
        id = employee.id;
        salary = employee.salary;
        date = employee.lastPayday;
    }
    
}