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
    mapping(address => Employee) public employees;

    function Payroll() payable public {
        totalSalary = 0;
    }
    
    modifier employeeExist(address employeeId) {
        Employee e = employees[employeeId];
        require(e.id == employeeId);   
    }
    
    function _partialPaid(address id) private {
        Employee employee = employees[id];
        uint payValue = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        //uint payValue = employee.salary * (now - employee.lastPayday) / payDuration;
        employees[id].lastPayday = now;
        employee.id.transfer(payValue);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner public {
        require(employeeId != owner);
        Employee e = employees[employeeId];
        assert(e.id == 0x0);
        
        uint salaryE = salary.mul(1 ether);
        employees[employeeId] = Employee({id:employeeId, salary:salaryE, lastPayday:now});
        totalSalary+=salaryE;
    }

    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) public {
        _partialPaid(employees[employeeId].id);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }

    function changePaymentAddress(address oldAddress, address newAddress) employeeExist(oldAddress) public {
        //require(newAddress != owner);
        //require(oldAddress != owner);
        // only employee change its address

        // not to an empty
        require(newAddress != 0x0);
        // not be able to change to other's address, otherwise will be a security issue
        assert(employees[newAddress].id == 0x0);
        require(newAddress != oldAddress);
        if(msg.sender == owner) {
            _partialPaid(oldAddress);
        } else {
            require(msg.sender == oldAddress);
            // not able to send to empty address
        }
            
        //employees[oldAddress].id = 0x0;
        uint salary = employees[oldAddress].salary;
        uint lastPayday = employees[oldAddress].lastPayday;
        delete employees[oldAddress];
        employees[newAddress] = Employee({id:newAddress, salary:salary, lastPayday:lastPayday});
    }

    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) public {
        _partialPaid(employeeId);
        uint salaryE = salary * 1 ether;
        //totalSalary = totalSalary - employees[employeeId].salary + salaryE;
        totalSalary = totalSalary.sub(employees[employeeId].salary).add(salaryE);
        employees[employeeId].salary = salaryE;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() employeeExist(msg.sender) public {
        //uint nextPayday = employees[msg.sender].lastPayday + payDuration;
        uint nextPayday = employees[msg.sender].lastPayday.add(payDuration);
        assert(nextPayday <= now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employees[msg.sender].id.transfer(employees[msg.sender].salary);
    }
}
