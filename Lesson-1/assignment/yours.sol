/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract PayRoll {
    uint salary = 1 ether;
    address employee = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint payDuration = 10 seconds;
    uint lastPayDay = now;
    
        function addFund() payable returns (uint) {
            return this.balance;
        }
        
        function setEmployee(address _employee) returns (address) {
            employee = _employee;
            return employee;
        }
        
        function setSalary(uint _salary) returns (uint) {
            salary = _salary;
            return salary;
        }
    
        function calculateRunWay() returns (uint) {
            return this.balance/salary;
        }
        
        function hasEnoughFund() returns (bool) {
            return calculateRunWay() > 0;
        }
        
        function getPaid() {
            if (msg.sender != employee){
                revert();
            }
            
            uint nextPayDay = lastPayDay + payDuration;
            if( nextPayDay > now) {
                revert();
            }
            
            lastPayDay = nextPayDay;
            employee.transfer(salary);
        }
}
