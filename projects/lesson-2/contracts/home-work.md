# 023_白广通_第二次作业

## 调用`calculateRunway()`Gas消耗记录

1. 加入第1个Employee后：transaction cost: **22974** gas, execution cost: **1702** gas
2. 加入第2个Employee后：transaction cost: **23755** gas, execution cost: **2483** gas
3. 加入第3个Employee后：transaction cost: **24536** gas, execution cost: **3264** gas
4. 加入第4个Employee后：transaction cost: **25317** gas, execution cost: **4045** gas
5. 加入第5个Employee后：transaction cost: **26098** gas, execution cost: **4826** gas
6. 加入第6个Employee后：transaction cost: **27660** gas, execution cost: **6388** gas
7. 加入第7个Employee后：transaction cost: **28441** gas, execution cost: **7169** gas
8. 加入第8个Employee后：transaction cost: **29222** gas, execution cost: **7950** gas
9. 加入第9个Employee后：transaction cost: **30003** gas, execution cost: **8731** gas
10. 加入第10个Employee后：transaction cost: **30784** gas, execution cost: **9512** gas

结论：调用所消耗的Gas量随Employee数量增加。
原因：`calculateRunway()`内部包含一个循环，Employee个数越多，循环次数越多，计算次数也越多，因此消耗Gas量也变大。

## 优化`calculateRunway()`以减少Gas消耗

可以使用一个状态变量`totalSalary`，记录contract中所有employee的salary之和，在`addEmployee()`, `removeEmployee()`和`updateEmployee()`中适当更新。
