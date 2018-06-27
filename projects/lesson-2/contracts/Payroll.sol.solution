pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 30 days;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() payable public {
        owner = msg.sender;
    }

    function _partialPaid(uint employeeIndex) private {
        uint payment = employees[employeeIndex].salary * (now - employees[employeeIndex].lastPayday) / payDuration;
        employees[employeeIndex].id.transfer(payment);
    }

    function _findEmployee(address employeeId) private view returns (int) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return int(i);
            }
        }
        return - 1;
    }

    function _calculateTotalSalaryVerySlow() private view returns (uint) {
        uint total = 0;
        for (uint i = 0; i < employees.length; i++) {
            total += employees[i].salary;
        }
        return total;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        int index = _findEmployee(employeeAddress);
        assert(index == - 1);
        salary = salary * 1 ether;
        employees.push(Employee(employeeAddress, salary, now));

        totalSalary += salary;
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        int index = _findEmployee(employeeId);
        assert(index > - 1);

        uint employeeIndex = uint(index);
        _partialPaid(employeeIndex);
        uint salary = employees[employeeIndex].salary;
        delete employees[employeeIndex];
        employees[employeeIndex] = employees[employees.length - 1];
        employees.length -= 1;

        totalSalary -= salary;
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        int index = _findEmployee(employeeAddress);
        assert(index > - 1);

        uint employeeIndex = uint(index);
        _partialPaid(employeeIndex);

        uint oldSalary = employees[employeeIndex].salary;
        salary = salary * 1 ether;
        employees[employeeIndex].salary = salary;
        employees[employeeIndex].lastPayday = now;

        totalSalary += salary - oldSalary;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        require(employees.length > 0);
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        int index = _findEmployee(msg.sender);
        assert(index > - 1);

        uint employeeIndex = uint(index);
        uint nextPayday = employees[employeeIndex].lastPayday + payDuration;
        assert(nextPayday < now);

        employees[employeeIndex].lastPayday = nextPayday;
        employees[employeeIndex].id.transfer(employees[employeeIndex].salary);
    }
}

