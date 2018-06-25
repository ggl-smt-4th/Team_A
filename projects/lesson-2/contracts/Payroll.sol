pragma solidity ^0.4.14;

contract Payroll {

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

    function addEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.addr != 0x0);
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);
        totalSalary += salary;
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.addr != 0x0);
        _payAllSalary(employees[employeeId]);
        delete employees[employeeId];
        totalSalary -= employee.salary;
    }

    function updateEmployee(address employeeId, uint salary) public {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        require(salary > 0);
        var employee = employees[employeeId];
        assert(employee.addr != 0x0);
        _payAllSalary(employees[employeeId]);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].addr = employeeId;
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayDay = now;
        totalSalary += salary;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        require(totalSalary > 0);
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        assert(employees[msg.sender].addr != 0x0);
        _payPerSalary(employees[msg.sender]);
    }

     function _payAllSalary(Employee storage employee) private {
        uint value = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.addr.transfer(value);
        employee.lastPayDay = now;
    }
    
    function _payPerSalary(Employee storage employee) private {
        uint newPayDay = employee.lastPayDay + payDuration;
        assert(newPayDay < now);
        employee.addr.transfer(employee.salary);
        employee.lastPayDay = newPayDay;
    }

}