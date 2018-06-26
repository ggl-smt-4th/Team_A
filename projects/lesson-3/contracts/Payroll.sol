pragma solidity ^0.4.14;


import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable{

    using SafeMath for uint;

    struct Employee {
        address addr ;
        uint salary ;
        uint lastPayDay ;
    }

    uint constant payDuration = 30 days;

    address owner;
    mapping(address => Employee) employees;

    uint totalSalary;


    function Payroll() payable public {
        owner = msg.sender;
    }

    
    modifier onlyEmployeeExists(address employeeId) {
        var employee = employees[employeeId];
        require(employee.addr != 0x0);
        _;
    }


    function addEmployee(address employeeId, uint salary) public onlyOwner {
        salary = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId,salary,now);
        totalSalary = totalSalary.add(salary);
    }

    function removeEmployee(address employeeId) public onlyOwner onlyEmployeeExists(employeeId){
        _payAllSalary(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        delete employees[employeeId];
        
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner onlyEmployeeExists(employeeId){
        salary = salary.mul(1 ether);
        // _payAllSalary(employees[employeeId]);
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        employees[employeeId].addr = employeeId;
        employees[employeeId].salary = salary;
        employees[employeeId].lastPayDay = now;
        totalSalary = totalSalary.add(salary);
    }
    
    function changePaymentAddress(address oldAddress, address newAddress) public onlyOwner onlyEmployeeExists(oldAddress){
        require(newAddress != 0x0);
        employees[newAddress] = Employee(newAddress,employees[oldAddress].salary,employees[oldAddress].lastPayDay);
        delete employees[oldAddress];
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        require(totalSalary > 0);
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public onlyEmployeeExists(msg.sender) {
        _payPerSalary(employees[msg.sender]);
    }

     function _payAllSalary(Employee storage employee) private {
        uint value = employee.salary.mul(now - employee.lastPayDay).div(payDuration);
        employee.addr.transfer(value);
        employee.lastPayDay = now;
    }
    
    function _payPerSalary(Employee storage employee) private {
        uint newPayDay = employee.lastPayDay.add(payDuration);
        assert(newPayDay < now);
        employee.addr.transfer(employee.salary);
        employee.lastPayDay = newPayDay;
    }

}