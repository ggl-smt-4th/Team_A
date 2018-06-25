+    依照第二课视频的样例代码可得到依次添加几个employee后相应的calculateRunway()的相应花销如下：
 +
 + 优化前：
 +  |operation       |transaction cost|execution cost | delta |
 + 1|calculateRunway |          22974 |          1702 |       |
 + 2|calculateRunway |          23755 |          2483 |  781  |
 + 3|calculateRunway |          24536 |          3264 |  781  |
 + 4|calculateRunway |          25317 |          4045 |  781  |
 + 5|calculateRunway |          26098 |          4826 |  781  |
 + 6|calculateRunway |          26879 |          5607 |  781  |
 + 7|calculateRunway |          27660 |          6388 |  781  |
 + 8|calculateRunway |          28441 |          7169 |  781  |
 + 9|calculateRunway |          29222 |          7950 |  781  |
 +10|calculateRunway |          30003 |          8731 |  781  |
 
 +
 +    观察相邻两次calculateRunway()的花费之差可知：每次transaction cost的增加都来自execution cost，而execution cost每次都会增加781以计算新加入的employee带来的工资开销。随着员工数量的增加，计算runway的花销将会越来越大。
 +    一个比较直接的思路是在contract里维护一个当前所有employee的工资开销之和totalSalary，每次更新employee相关信息的的时候将其一同更新，在调用calculateRunway()的时候就可以直接获取该值而无需遍历全体employee重新计算。
 +    利用变量totalSalary存储当前全体employee的salary后，几次calculateRunway()的相应花销如下：
 +
 +优化后：
 +  |operation       |transaction cost|execution cost
 +---------------------------------------------------
 + 1|calculateRunway |          22371 |          1099
 + 2|calculateRunway |          22371 |          1099
 + 3|calculateRunway |          22371 |          1099
