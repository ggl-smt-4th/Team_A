优化思路：取消calculateRunway函数中，for循环查询计算totalsalary过程，将totalsalary定义为全局变量，每当addEmployee、removeEmployee和updateEmployee时，接收变化的salary，这样就避免点击一次calculateRunway，运行一次for。可以看到，当轮次（员工数）越来越多，gas消耗减少的越明显。

优化前：
第1次（gas:1702）；第2次（gas:2483）；第3次（gas:3264）；第4次（gas:4045）；第5次（gas:4826）；第6次（gas:5607）；第7次（gas:6300）；第8次（gas:7169）；第9次（gas:7990）；第10次（gas:8731）。

优化后：
第1次（gas:860）；第2次（gas:860）；第3次（gas:860）；第4次（gas:860）；第5次（gas:860）；第6次（gas:860）；第7次（gas:860）；第8次（gas:860）；第9次（gas:860）；第10次（gas:860）。
