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
    uint totalSalary;

    function Payroll() payable public {
        owner = msg.sender;
        totalSalary = 0;
    }

    function _partialPaid(Employee employee) private returns (bool) {
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

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeAddress);
        assert(employee.id == 0x00);

        salary = salary * 1 ether;
        employees.push(Employee(employeeAddress,salary,now));
        totalSalary += salary;
    }

    function removeEmployee(address employeeAddress) public {
        require(msg.sender == owner);
        var (employee,index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x00);
        _partialPaid(employee);
        totalSalary = totalSalary - employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeAddress);
        assert(employee.id != 0x00);

        salary = salary * 1 ether;
        _partialPaid(employee);
        totalSalary = totalSalary - employee.salary + salary;
        employees[index].id = employeeAddress;
        employees[index].salary = salary;
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
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id == 0x00);

        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);

        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
