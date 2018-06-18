pragma solidity ^0.4.14;

contract Payroll {

    uint salary = 1 ether;
    address boss;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    //initial boss address
    function Payroll() {
       boss = msg.sender;
    }
    
    //only boss can set salary
    function setSalary(uint s){
        if(msg.sender != boss){
            revert();
        }
        
        salary = s*1 ether;
    }

    function getSalary() returns (uint) {
        return salary;
    }  
    
    //only boss can set employee address
    function setAddress(address addr){
        if(msg.sender != boss){
            revert();
        }
        
        employee = addr;
    }
    
    function getAddress() returns(address){
        return employee;
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
        if(msg.sender != employee){
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        if(nextPayday > now){
            revert();
        }
        lastPayday = nextPayday;
        employee.transfer(salary);
    }
}