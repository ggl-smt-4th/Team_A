pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary = 1 ether;
    address employee;
    uint lastPayday = now;

    function Payroll() {
        owner = msg.sender;
        lastPayday = now;
    }

    //update address 
    function updateEmployeeAddress(address _address) {
        require(msg.sender == owner);
        
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            address old = employee;
            employee = _address;
            lastPayday = now;
            if(payment > 0){
                 old.transfer(payment);
            }
            return; 
        }
        
        employee = _address;
        lastPayday = now;
    }
    
    //update salary
    function updateEmployeeSalary(uint _salary) {
        require(msg.sender == owner);
        
        salary = _salary * 1 ether;
    }
        

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        require(msg.sender == employee);

        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);

        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}
