pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    
    mapping (address => Employee) public employees;
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function Payroll() payable Ownable() public {
        
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = (employee.salary.mul(now.sub(employee.lastPayday))).div(payDuration);
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) public {
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salary, now);

        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);
        
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) employeeNotExist(newAddress) public {
        var oldEmployee = employees[oldAddress];
        employees[newAddress] = Employee(newAddress, oldEmployee.salary, oldEmployee.lastPayday);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        var employee = employees[employeeId];
        _partialPaid(employee);

        totalSalary = totalSalary.sub(employee.salary);
        salary = salary.mul(1 ether);
        employee.salary = salary;
        employee.lastPayday = now;

        totalSalary = totalSalary.add(salary);
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}