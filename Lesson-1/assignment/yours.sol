/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    address employer;   
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c; // default employee
    uint salary = 1;                            // default salary = 1
    uint constant payDuration = 10 seconds;     // default pay duraion = 10 seconds
    uint lastPayday = now; 
    
    function Payroll(){                         // employer is the contract constuctor
        employer = msg.sender;
    }
    
    function setEmployee(address em){           // only the employer can set the employee
        if(msg.sender != employer){
            revert();
        }
        employee = em;
    }
    
    function setSalary(uint x){                 // only the employer can set the salary
        if(msg.sender != employer){
            revert();
        }
        salary = x;
    }
    
    function addFund() payable returns (uint){  // add fund to the contract
        return this.balance;
    }
    
    function computeRunaway() returns (uint){   // compute the paying runaway 
        return this.balance / salary;
    }
    
    function getPaid() returns (bool){          // only the employee can get paid
        if(msg.sender != employee){
            revert();
        }
        
        if(this.balance < salary){              // If money isn't enough, fail
            revert();
        }
        
        uint nextPayday = lastPayday + payDuration;
        
        if(nextPayday > now){
            revert();
        }
        
        lastPayday = nextPayday;
        employee.transfer(salary);
        return true;
    }
}
