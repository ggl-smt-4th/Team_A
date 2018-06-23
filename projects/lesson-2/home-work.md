优化思路：取消calculateRunway函数中，for循环查询计算totalsalary过程，将totalsalary定义为全局变量，每当addEmployee、removeEmployee和updateEmployee时，接收变化的salary，这样就避免点击一次calculateRunway，运行一次for。可以看到，当轮次（员工数）越来越多，gas消耗减少的越明显。


优化前：
轮次      gas消耗
1         1702
2         2483
3         3264
4         4045
5         4826
6         5607
7         6300
8         7169
9         7990
10        8731

优化后：
轮次      gas消耗
1         860
2         860
3         860
4         860
5         860
6         860
7         860
8         860
9         860
10        860
