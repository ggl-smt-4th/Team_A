pragma solidity ^0.4.14;

contract Payroll {
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 30 days;
    uint totalsalary = 0;
    
    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;    
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee,uint) {
        for(uint i = 0;i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i],i);
            }
        }
    }
    
    function addEmployee(address employeeId,uint n) {
        uint salary;
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        salary = n * 1 ether;
        totalsalary += salary;  //increase salary
        employees.push(Employee(employeeId,salary,now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalsalary -= employees[index].salary;  //reduce salary
        
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
       
    
    function updateEmployee(address employeeId,uint salary) {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalsalary -= employees[index].salary;   //The first step is to delete old salary
        employees[index].salary = salary * 1 ether;
        totalsalary += employees[index].salary;   //The second step is to add new salary
        employees[index].lastPayday = now;
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
    
    function getPaid() {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
        
    }
}
