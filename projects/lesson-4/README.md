### 作业

在 `projects/lesson-4/test` 文件夹中，放入 js 测试文件，写出以下函数的单元测试：

*   `addEmployee(address employeeId, uint salary)`

*   `removeEmployee(address employeeId)`

*   `getPaid()`

思考如何能覆盖所有的测试路径，包括

*   各函数调用者权限

*   重复调用

*   异常捕捉

`getPaid()` 函数需要在一定时间之后调用才可领薪酬，思考如何对 timestamp 进行修改，是否需要对所测试的合约进行修改来达到测试的目的？
