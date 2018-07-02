pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {

    using SafeMath for uint;

    struct Employee {
        // TODO, your code here
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint public totalSalary = 0;
    uint public totalEmployee = 0;
    mapping(address => Employee) public employees;

    modifier employeeExist(address employeeId) {
        assert(employees[employeeId].lastPayday != 0);
        _;
    }

    modifier employeeNotExist(address employeeId) {
        assert(employees[employeeId].lastPayday == 0);
        _;
    }

    function Payroll() payable public {
        // TODO: your code here
        owner = msg.sender;
    }

    function _partialPaid(address employeeId) private employeeExist(employeeId) {
        uint payment = employees[employeeId].salary
            .mul(now.sub(employees[employeeId].lastPayday))
            .div(payDuration);
        employees[employeeId].id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExist(employeeId){
        // TODO: your code here
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salary, now);

        totalSalary = totalSalary.add(salary);
        totalEmployee = totalEmployee.add(1);
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        // TODO: your code here
        _partialPaid(employeeId);
        uint salary = employees[employeeId].salary;
        totalSalary = totalSalary.sub(salary);
        totalEmployee = totalEmployee.sub(1);

        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeeExist(oldAddress) employeeNotExist(newAddress) {
        // TODO: your code here
        _partialPaid(oldAddress);
        employees[newAddress] = Employee(newAddress, employees[oldAddress].salary, now);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
        // TODO: your code here
        var employee = employees[employeeId];
        _partialPaid(employeeId);
        uint oldSalary = employee.salary;
        salary = salary.mul(1 ether);
        employee.salary = salary;
        employee.lastPayday = now;

        totalSalary = totalSalary.add(salary).sub(oldSalary);
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        // TODO: your code here
        require(totalSalary > 0);
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        // TODO: your code here
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) {
        // TODO: your code here
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        require(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
