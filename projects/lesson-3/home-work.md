1.  合约产品化
使用modifier判断
使用safeMath计算
函数调用gas花费
Function Name	Transaction cost	Execution Cost
Payroll	      1489584	    1085956
addFund	      21965	      693
addEmployee  	105180    	82308
addEmployee(2)	90180	    67308
addEmployee(3)	90180	    67308
addEmployee(4)	90180    	67308
changePaymentAddress(employee)	57112	78024
changePaymentAddress(owner)	70872	91784
removeEmployee	29386	36091
updateEmployee	73477	50605
calculateRunway	22230	958
hasEnoughFund	22239	967
getPaid	35641	14369


2.  C3 Lineraization 继承顺序

L(O)  := [O]  // O has no parent

L(A)  := [A] + merge(L(O), [O])                 // L(A) IS A PLUS ITS PARENT
       = [A] + merge([O], [O])
       = [A, O]
L(B)  := [B, O]
L(C)  := [C, O]

L(K1) := [K1] + merge(L(A), L(B), [A,B])       // MERGE PARENTS and PARENT LIST
       = [K1] + merge([A,O]+[B,O]+[A,B])       // A IS GOOD, CAUSE A IS ONLY HEAD OF FIRST AND LAST LISTS
       = [K1, A] + merge([O], [B,O], [B])      // O IS NOT GOOD, APPEARS IN TAIL 2, B GOOD
       = [K1, A, B] + merge([O], [O])          // O GOOD
       = [K1, A, B, O]
L(K2) := [K2, A, C, O]

L(Z)  := [Z] + merge(L(K1), L(K2), [K1,K2])              // MERGE PARENTS and PARENT LIST
       = [Z] + merge([K1,A,B,O], [K2,A,C,O], [K1,K2])    // K1 good
       = [Z, K1] + merge([A,B,O], [K2,A,C,O],[K2])       // K2 good
       = [Z, K1, K2] + merge([A,B,O], [A,C,O])           // A
       = [Z, K1, K2, A] +merge([B,O]+[C,O])              // B
       = [Z, K1, K2, A, B] + merge([O]+[C,O])            // C
       = [Z, K1, K2, A, B, C] + merge([O]+[O])
       = [Z, K1, K2, A, B, C, O]
