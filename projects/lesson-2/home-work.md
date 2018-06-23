### home-work

* 调用calculateRunway时 gas的变化情况
	1. 22974
	2. 23755
	3. 24536
	4. 25317
	5. 26089
	6. 26879
	7. 27669
	8. 28441
	9. 29222
	10.	30003

* 优化calculateRunway函数
	1. calculateRunway并不改变合约的状态,可以是一个只读的接口.在外部调用的时候,可以使用call而不是sendTransaction,这样就不用花费gas了.

	2. 如果在calculateRunway内部优化,只能是优化循环叠加的操作,那么思路就是合约里维护一个工资总额,每次工资变动的时候更新工资总额,这样那个就不用每次循环叠加了.
