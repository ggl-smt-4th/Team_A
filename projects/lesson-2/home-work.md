Number of employees added: 1     
execution cost: 1702 gas

Number of employees added: 2    
execution cost: 2483 gas

Number of employees added: 3    
execution cost: 3264 gas

Number of employees added: 4     
execution cost: 4045 gas

Number of employees added: 5     
execution cost: 4826 gas

Number of employees added: 6    
execution cost: 5607 gas

Number of employees added: 7     
execution cost: 6388 gas

Number of employees added: 8     
execution cost: 7169 gas

Number of employees added: 9    
execution cost: 7950 gas

Number of employees added: 10    
execution cost: 8731 gas

因为每次计算calculateRunway(), 所有员工的salary都需要相加，所以员工越多，需要的计算越多，gas也越多，而且有很多重复计算。

优化方案：添加totalSalary作为全局变量，每次addEmployee，removeEmployee和updateEmployee都更新totalSalary。 这样每次计算calculateRunway就可以直接获取totalSalary，而不需要再计算，优化后每次运行calculateRunway()都只需要860 gas.