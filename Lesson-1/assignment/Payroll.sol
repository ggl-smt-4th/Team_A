pragma solidity ^0.4.14;

contract Payroll {

    //初始薪水
    uint salary = 1 ether;
    
    //老板钱包地址
    address boss;
    
    //员工钱包地址
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    //初始化老板地址为执行合约地址
    function Payroll() {
       boss = msg.sender;
    }
    
    //只有老板可以设置员工薪水
    function setSalary(uint s){
        if(msg.sender != boss){
            revert();
        }
        
        salary = s*1 ether;
    }

    function getSalary() returns (uint) {
        return salary;
    }  
    
    //只有老板可以设置员工钱包地址
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