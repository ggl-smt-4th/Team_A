/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address boss;
    address employer;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function Payroll() {
        boss = msg.sender;
    }
    
    function update_employer(uint n,address s) {
        employer = s;
        salary = n * 1 ether;
    }
    
    function addFund(address s) payable returns (uint) {
        require(boss == s);
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid(address s) {
        require(employer == s);
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        lastPayday = nextPayday;
        employer.transfer(salary);
    }
    
    function currentPaid(address s) returns (uint) {
        require(employer == s);
        return employer.balance;
    }
}
