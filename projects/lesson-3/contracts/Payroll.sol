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
    
    mapping (address => Employee) public employees;
    address owner;
    uint public totalSalary = 0;
    
    function _partialPaid(Employee employee) private {
        uint payment = (employee.salary.mul(now.sub(employee.lastPayday))).div(payDuration);
        employee.id.transfer(payment);
    }
    
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
    
    function addEmployee(address employeeId, uint salary) public onlyOwner employeeNotExist(employeeId) {
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(salary.mul(1 ether));
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner employeeExist(oldAddress) {
        var employee = employees[oldAddress];
        employees[newAddress] = Employee(newAddress, employee.salary, employee.lastPayday);
        delete employees[oldAddress];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];

        totalSalary = totalSalary.add((salary.mul(1 ether)).sub(employee.salary));
        employees[employeeId].salary = salary.mul(1 ether);
        _partialPaid(employee);
        employees[employeeId].lastPayday = now;

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

        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
