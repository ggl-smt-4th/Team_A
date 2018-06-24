## GAS 记录
calculateRunWay
Cost only applies when called by a contract
transaction cost   23877 gas
transaction cost   24658 gas
transaction cost   25439 gas
transaction cost  26220 gas
transaction cost  27001 gas 

Cost only applies when called by a contract
 execution cost     2605 gas
 execution cost     3386 gas
 execution cost     4167 gas
 execution cost     4948 gas
 execution cost     5729 gas

## calculateRunWay函数的优化方案

### 为什么在每次增加Employee之后，消耗会变大？
因为存放员工信息的数组变大，而每次计算中的消耗的时候，需要遍历整个数组，计算量也变大了。
所以消耗也变大了。

### 优化
通过一个成员变量，来保存calculateRunWay函数的计算结果。
当增加、修改、删除的时候，更新这个变量。
每次调用calculateRunWay函数的时候，直接将变量的值返回。