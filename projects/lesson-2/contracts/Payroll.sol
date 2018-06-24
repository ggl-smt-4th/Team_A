pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address addr ;
        uint salary ;
        uint lastPayDay ;
    }

    uint constant payDuration = 30 days;

    address owner;
    Employee[] employees;

    uint calculateRunWayValue;


    function Payroll() payable public {
        owner = msg.sender;
    }

    function addEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        uint index = _findEmployee(employeeAddress);
        assert(index == employees.length);
        employees.push(Employee(employeeAddress,salary * 1 ether,now));
        updateCalculateRunWay();
    }

    function removeEmployee(address employeeId) public {
        require(msg.sender == owner);
        uint index = _findEmployee(employeeId);
        assert(index < employees.length);
        _payAllSalary(employees[index]);
        employees[index] = employees[employees.length - 1];
        delete employees[employees.length - 1];
        updateCalculateRunWay();
    }

    function updateEmployee(address employeeAddress, uint salary) public {
        require(msg.sender == owner);
        require(employeeAddress != 0x0);
        require(salary > 0);
        uint index = _findEmployee(employeeAddress);
        assert(index < employees.length);
        Employee storage employee = employees[index];
        _payAllSalary(employee);
        employee.addr = employeeAddress;
        employee.salary = salary * 1 ether;
        employee.lastPayDay = now;
        updateCalculateRunWay();
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return calculateRunWayValue;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function updateCalculateRunWay() private{
        uint totalSalary = 0;
        for(uint i = 0 ; i < employees.length;i ++){
            totalSalary += employees[i].salary;
        }
        totalSalary = totalSalary == 0 ? 1 : totalSalary;
        calculateRunWayValue = address(this).balance / totalSalary;
    }

    function getPaid() public {
        uint index = _findEmployee(msg.sender);
        assert(index < employees.length);
        _payPerSalary(employees[index]);
        updateCalculateRunWay();
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
    
    function _findEmployee(address employeeId) private view returns (uint){
        uint index = employees.length;
        for(uint i = 0 ; i < employees.length ; i ++){
            if(employeeId == employees[i].addr){
                index = i;
                break;
            }
        }
        return index;
    }
}