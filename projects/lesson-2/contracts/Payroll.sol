pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;
    uint totalSalary = 0 ether;

    function Payroll() payable public {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
       
        employees.push(Employee(employeeId, salary, now));
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -=1;
    }
    
    
    function updateEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary += (salary * 1 ether - employee.salary);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        require(this.balance >= employee.salary);
        
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
        
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

