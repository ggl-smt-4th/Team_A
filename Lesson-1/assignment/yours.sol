/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {
    uint salary = 1 ether;
    address boss;
    address employer;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function Payroll() {    //By default,the deployment account is a boss account
        boss = msg.sender;
    }
    
    function update_address(address s) {  //change the employer address
        employer = s;
    }
    
    function update_salary(uint n) {      //change the employer salary
        clearoldsalary();
        salary = n * 1 ether;
    }
    
    function addFund(address s) payable returns (uint) {   //Boss account can increase money
        require(boss == s);
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function clearoldsalary() {   //clear the current account salary
        uint payment = salary * ((now - lastPayday) / payDuration);
        employer.transfer(payment);
        lastPayday = now;
    }
    
    function getPaid(address s) {   //Only employee can get account balance
        require(employer == s);
        uint nextPayday = lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        lastPayday = nextPayday;
        employer.transfer(salary);
    }
    
    function currentPaid(address s) returns (uint) {   //Only employee can check account balance
        require(employer == s);
        return employer.balance;
    }
}
