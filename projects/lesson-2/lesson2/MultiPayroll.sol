pragma solidity ^0.4.14;
 
 contract MultiPayroll {


     struct Employee {
         address id;
         uint salary;
         uint lastPayday;
     }
 
     uint constant payDuration = 30 days;
     //uint constant payDuration = 10 seconds;
     uint totalSalary = 0;
     address owner;
     Employee[] employees;
 
     function MultiPayroll() payable public {
         owner = msg.sender;
     }

     function _partialPay(Employee employee) private {
         uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
         employee.id.transfer(payment);        
     }

     function _findEmployee(address employeeId) private returns (Employee, uint) {
         for(uint i=0; i < employees.length; i++) {
             if(employees[i].id == employeeId) {
                 return (employees[i], i);
             }
         }
     }
     
     function addEmployee(address employeeAddress, uint salary) public {
         require(msg.sender == owner);

         var (employee, index)  = _findEmployee(employeeAddress); 
         assert(employee.id == 0x0);
 
         totalSalary += salary;///
         employees.push(Employee(employeeAddress, salary * 1 ether, now));
     }
 
     function removeEmployee(address employeeId) public {
         require(msg.sender == owner);
         var (employee, index)  = _findEmployee(employeeId); 
         assert(employee.id != 0x0);

         _partialPay(employee);       
 
         totalSalary -= employees[index].salary;///
         delete employees[index];

         employees[index] = employees[employees.length - 1];
         employees.length -= 1;
     }

     function updateEmployee(address employeeAddress, uint salary) public {
         require(msg.sender == owner);
         var (employee, index)  =_findEmployee(employeeAddress); 
         assert(employee.id != 0x0);
         //assert(index > -1);
         
         _partialPay(employee);      
         
         uint oldSalary = employees[index].salary;///
         salary = salary * 1 ether;///
         employees[index].salary = salary;
         employees[index].lastPayday = now;
 
         totalSalary += salary - oldSalary;///
     }
 
     function addFund() payable public returns (uint) {
         //return this.balance;
         return address(this).balance;
     }
 
     function calculateRunway() public view returns (uint) {
         require(employees.length > 0);
         return address(this).balance / totalSalary;
     }
 
     function hasEnoughFund() public view returns (bool) {
         return calculateRunway() > 0;
     }

     function getPaid() payable public {
         var (employee, index)  = _findEmployee(msg.sender); 
         assert(employee.id != 0x0);
 
         uint nextPayday =employee.lastPayday + payDuration;
         assert(nextPayday < now);
 
         employees[index].lastPayday = nextPayday;
         employees[index].id.transfer(employees[index].salary);
     }
 }