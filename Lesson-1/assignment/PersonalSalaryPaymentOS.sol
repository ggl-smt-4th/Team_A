pragma solidity ^0.4.21;
contract PersonalSalaryPayment {

    uint salary = 3 ether;
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 1 minutes;
    uint lastPayDay = now;

    function addFund() payable returns(uint) {
        return this.balance;
    }

    function calculateRunWay() view returns(uint){
        return this.balance / salary;
    }

    function hasEnoughFundForNextMonth() view returns(bool){
        return calculateRunWay() > 0 ;
    }

    function getSalary(){
        if (msg.sender != frank){
            revert();
        }
        uint tempNewLastPayDay = lastPayDay + payDuration;
        if (tempNewLastPayDay > now){
            revert();
        }
        lastPayDay = tempNewLastPayDay;
        frank.transfer(salary);
    }



    function setFrankAddress(address newFrank){
        // transfer salary to old frank
        uint allSalary = getTotalSalay();
        if(this.balance > allSalary){
            lastPayDay = now;
            frank.transfer(allSalary);
        }else{
            revert();
        }
        frank = newFrank;
    }

    // all salary of frank have not get
    function getTotalSalay() returns(uint){
        uint totalDuration = now - lastPayDay ;
        uint times = totalDuration / payDuration;
        return times * salary ;
    }

    function setSalary(uint newSalary){
        // transfer salary to old frank
        uint allSalary = getTotalSalay();
        if(this.balance > allSalary){
            lastPayDay = now;
            frank.transfer(allSalary);
        }else{
            revert();
        }
        salary = newSalary;
    }

}
