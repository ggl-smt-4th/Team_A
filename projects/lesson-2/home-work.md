(ii) calculateRunaway()函数的gas消耗变化的记录(execeution cost):

     1702 -> 2483 -> 3264 -> 4045 -> 4826 -> 5607 -> 6388 ->7169 -> 7950 ->8731

     可以看出, 添加第i位员工后, calculateRunaway()函数的其gas消耗为
     
     gi = 781 * i  + 921

     这是由于每次calculateRunaway函数都需要loop整个employees数组，数组越大，gas消耗越多.
     
(iii) calculateRunway()函数优化:

     如果实际过程中calculateRunway()函数经常被call, 那么考虑在contract中添加成员变量totalSalary记录当前总薪水,
     
     每次employees数组有变化时, totalSalary也跟着变化, 而calulateRunway()函数则直接调用成员变量totalSalary.
     
     重新部署合约，依次添加5位员工, 运行后发现calculateRunaway()函数的gas消耗变化记录为
     
     860 -> 860 -> 860 -> 860 -> 860  
     
     即calulateRunway()函数的gas消耗保持为常数860,
     
     这即是对calculateRunway()函数的优化.
