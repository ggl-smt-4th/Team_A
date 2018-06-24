### 作业

1. 完成今天所开发的合约产品化内容

2. 增加 `changePaymentAddress()` 函数，更改员工的薪水支付地址，思考一下能否使用 modifier 整合某个功能

    * **复制 `projects/lesson-3/contracts/Payroll.sol.sample` 到 `projects/lesson-3/contracts/Payroll.sol` 并实现相关 TODO 处的代码**
    * 提交时请修改为 `payDuration = 30 days` 
    * 保持各 public 的函数名不变。

3. 加分题：自学 C3 Linearization, 求以下 contract Z 的继承线

    ```
    contract O
    contract A is O
    contract B is O
    contract C is O
    contract K1 is A, B
    contract K2 is A, C
    contract Z is K1, K2
    ```

对于非 Windows 用户，安装 docker 后，运行 `sh manager.sh run_test` 可测试合约是否满足基本要求。
