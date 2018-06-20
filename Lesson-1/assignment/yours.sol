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
    
    uint constant payDuration = 10 seconds;
    uint totalEmployee = 1;
    Employee employee;
    
    /** 
     * @dev The constructor sets the contract owner and employee info.
     */
    function Payroll(address _id, uint _salary, uint _lastPayday) payable {
        //owner = ownerAddr;
        employee = Employee(_id, _salary.mul(1 ether), _lastPayday);
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
    
    function updateEmployeeId(address employeeId) onlyOwner employeeValid(employeeId) {
        _partialPaid(employee);
        employee.lastPayday = now;
        employee.id = employeeId;
    }
    
    function updateEmployeeSalary(uint salary) onlyOwner {
        _partialPaid(employee);
        employee.lastPayday = now;
        employee.salary = salary;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance.div(employee.salary);
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeValid(msg.sender) {
        assert(employee.id == msg.sender);

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function checkInfo() returns (address id, uint salary, uint date) {
        id = employee.id;
        salary = employee.salary;
        date = employee.lastPayday;
    }
    
}