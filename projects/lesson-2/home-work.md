### 2nd homework

gas for every added employee (total = 10):
transactionCost executionCost
23048 1776
23836 2564
24624 3352
25412 4140
26200 4928
26988 5716
27776 6504
28564 7292
29352 8080
30140 8868

The original implementation of "calculateRunway()" requires calculation of total salary by traversing the whole "employees" array, which makes the cost of gas strictly increase for every added employee as above. The optimization is to assign a new state variable "totalSalary", and update "totalSalary" in "addEmployee()", "removeEmployee()" and "updateEmployee()" operations. The optimized implementation reduces the gas cost to a constant "22199 927".
