pragma solidity ^0.4.14;

/**
 * @title Payroll
 * @dev A payroll system for multiple employee.
 */

import './SafeMath.sol';

contract Payroll {
    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    uint totalSalary;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    modifier employeeValid(address employeeId) {
        assert(employeeId != 0x0);
        _;
    }
    
    function _partialPaid(Employee employeeCurr) private employeeValid(employeeCurr.id) {
        uint payment = employeeCurr.salary
            .mul(now.sub(employeeCurr.lastPayday))
            .div(payDuration);
        employeeCurr.id.transfer(payment);
    }

    function findEmployee(address employeeId) public returns (uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return i;
            }
        }
        return employees.length;
    }

    function addEmployee(address employeeId, uint salary) public employeeValid(employeeId) {
        require(msg.sender == owner);
        // TODO: your code here
        require(findEmployee(employeeId) == employees.length);

        var employee = Employee(employeeId, salary.mul(1 ether), now);
        employees.push(employee);
        totalSalary = totalSalary.add(employee.salary);
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        // TODO: your code here
        uint tmpId = findEmployee(employeeId);
        require(tmpId < employees.length);

        var employee = employees[tmpId];
        _partialPaid(employee);
        delete employees[tmpId];
        employees[tmpId] = employees[employees.length - 1];
        employees.length -= 1;
        totalSalary = totalSalary.sub(employee.salary);
    }

    function updateEmployee(address employeeId, uint salary) public employeeValid(employeeId) {
        require(msg.sender == owner);
        // TODO: your code here
        uint tmpId = findEmployee(employeeId);
        var employee = employees[tmpId];
        if (tmpId < employees.length) {
            _partialPaid(employee);
            totalSalary = totalSalary.sub(employee.salary);
            employee.salary = salary.mul(1 ether);
            employee.lastPayday = now;
            totalSalary = totalSalary.add(employee.salary);
        } else {
            addEmployee(employeeId, salary);
        }
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public constant returns (uint) {
        // TODO: your code here
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public constant returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeValid(msg.sender) {
        // TODO: your code here
        uint tmpId = findEmployee(msg.sender);
        require(tmpId < employees.length);

        uint nextPayday = employees[tmpId].lastPayday.add(payDuration);
        require(nextPayday < now);

        employees[tmpId].lastPayday = nextPayday;
        employees[tmpId].id.transfer(employees[tmpId].salary);
    }
    
    function checkInfo() returns (uint balance, uint employeeCount, uint budget) {
        return (address(this).balance, employees.length, totalSalary);
    }
}
