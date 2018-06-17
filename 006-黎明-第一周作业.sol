pragma solidity ^0.4.14;

contract Payroll {

    uint salary;
    address payee;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function setSalary(uint s){
        salary = s;
    }

    function getSalary() returns (uint) {
        return salary;
    }  
    
    function setAddress(address addr){
        payee = addr;
    }
    
    function getAddress() returns(address){
        return payee;
    }
    
    function addFund() payable returns(uint){
        return this.balance;
    }
    
    function getBalance() returns (uint) {
        return this.balance;
    }  

    function caculateRunway() returns (uint) {
        return this.balance / salary;
    }    
    
    function hasEnoughFund() returns(bool) {
        return caculateRunway() >  0;
    }
    
    function getPaid() payable{
        if(msg.sender != payee){
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now){
            revert();
        }
        lastPayday = nextPayday;
        payee.transfer(salary);
    }
}
