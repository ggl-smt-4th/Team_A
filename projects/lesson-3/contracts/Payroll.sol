pragma solidity ^0.4.14;

import './Ownable.sol';
import './SafeMath.sol';

contract Payroll is Ownable{
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 30 days;
    uint totalsalary = 0;
    
    mapping(address => Employee) public employees;

    function Payroll() payable {
        
    }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier partialPaid(address employeeId) {
        var employee = employees[employeeId];
        uint payment = employee.salary
                        .mul(now.sub(employee.lastPayday))
                        .div(payDuration);
        employee.id.transfer(payment);
        _;
    }
    
    function addEmployee(address employeeId,uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId,salary.mul(1 ether),now);
        totalsalary = totalsalary.add(employees[employeeId].salary);   //increase salary
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner partialPaid(oldAddress){
        require(oldAddress != newAddress);
        assert(employees[newAddress].id == 0x0);
        
        var employee = employees[oldAddress];
        
        uint salary = employee.salary;
        uint lastPayday = employee.lastPayday;
        
        employees[newAddress] = Employee(newAddress,salary,lastPayday);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) partialPaid(employeeId){
        var employee = employees[employeeId];
        totalsalary = totalsalary.sub(employees[employeeId].salary);  //reduce salary
        delete employees[employeeId];
    }
       
    
    function updateEmployee(address employeeId,uint salary) onlyOwner employeeExist(employeeId) partialPaid(employeeId) {
        var employee = employees[employeeId];
        totalsalary = totalsalary.sub(employees[employeeId].salary);   //The first step is to delete old salary
        employees[employeeId].salary = salary.mul(1 ether);
        totalsalary = totalsalary.add(employees[employeeId].salary);   //The second step is to add new salary
        employees[employeeId].lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {  //Gas reduced from 8731 to 860
        return this.balance / totalsalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
        
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        
        employees[msg.sender].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
