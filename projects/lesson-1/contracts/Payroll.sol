pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds; // while 'constant' serves as only 
                                            // a visual signal for functions,  
                                            // it DOES have real constraints 
                                            // on variables.
    address employer;
    uint salary = 1 ether;
    address employee;
    uint lastPayday;

    function Payroll() payable public { // only functions modified with 
                                        // 'payable' can receive money
        employer = msg.sender;
        lastPayday = now;
    }

    // pay remaining salary before updating employee's address or salary
    function payRemaining() internal {
        if (employee != 0x0){
            uint payment = salary * ((now - lastPayday) / payDuration);
            employee.transfer(payment);
        }
        lastPayday = now;
    }

    function updateEmployeeAddress(address newAddress) public {
        require(msg.sender == employer);
        require(newAddress != employer);
        payRemaining();
        employee = newAddress;
    }

    function updateEmployeeSalary(uint newSalary) public {
        require(msg.sender == employer);
        require(newSalary > 0);
        newSalary = newSalary * 1 ether;
        require(newSalary != salary);
        payRemaining();
        salary = newSalary;
    }

    function getEmployee() view public returns (address) {
        return employee;
    }

    function addFund() payable public returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() view public returns (uint) {
        return address(this).balance / salary;
    }

    function getSalary() view public returns (uint) {
        return salary;
    }

    function hasEnoughFund() view public returns (bool) {
        return calculateRunway() > 0;   // do NOT call with 'this' keyword, 
                                        // which will pay much gas
    }

    function getPaid() public {
        require(msg.sender == employee);    // only the right employee can 
                                            // call this function to get 
                                            // himself paid
        uint nextPayday = lastPayday + payDuration; // calculate this sum only 
                                                    // once to avoid the gas 
                                                    // overhead of repetitive 
                                                    // computation
        assert(nextPayday < now);
        // ORDER matters here (re-entry attack?): need to change internal 
        // variables first, then transfer monay to outer world
        lastPayday = nextPayday;
        employee.transfer(salary);  // 'transfer' will throw exception, 
                                    // while 'send' will not
    }
}