pragma solidity ^0.4.14;

contract Payroll {

    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint salary = 1 ether;
    uint payDuration = 10 seconds;
    uint lastPayday = now;

    function setEmployee(address e) {
        if(employee == e) {
            revert();
        }
        transferOldPayment();
        employee = e;
    }
    
    function setSalary(uint s) {
        
        if(salary == s) {
            revert();
        }
        transferOldPayment();
        salary = s * 1 ether;
    }
    
    function transferOldPayment() {
        uint payment = salary * (now - lastPayday) / payDuration;
        employee.transfer(payment);
        lastPayday = now;
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

    function getPaid() returns (uint) {
        
        if(msg.sender != employee) {
            revert();
        }

        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now) {
            revert();
        }
        
        lastPayday = nextPayday;
        employee.transfer(salary);
        return salary; 
    }
}
