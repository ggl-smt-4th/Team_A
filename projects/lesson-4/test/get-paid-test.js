var Payroll = artifacts.require("./Payroll.sol");
contract('Test remove employee in Payrool',function(accounts){
	console.log('Test --- begin---');
	console.log('accounts:'+accounts[0] + '--' + accounts.length);

	const owner = accounts[0];
	const employeeOne = accounts[1];
	const employeeTwo = accounts[2];
	const guest = accounts[3];


	const salaryOne = 1 ;
	const salaryTwo = 1 * 2 ;
	const fund = salaryTwo * 10;

	const totalFund = 10 ;

	const payDuration = (30 + 1) * 86400;

	var payrool;
	it ('get paid',function(){
		return Payroll.deployed()
				.then(function(instance){
					payrool = instance;
					return payrool.addEmployee(employeeOne,salaryOne,{from:owner});
				})
				.then(function(){
					console.log('更新时间');
					return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
				})
				.then(()=>{
					return payrool.addFund({from:owner,value:web3.toWei(fund, 'ether')});
				})
				.then(function(){
					console.log('提取工资');
					return payrool.getPaid({from:employeeOne});
				})
				.then(()=> {
					return payrool.calculateRunway();
				})
				.then((ret)=>{	
					assert.equal(ret.toNumber(),fund / salaryOne - 1 ,'异常');
				});
	});

	it('get paid by guest',function(){
		return payrool.getPaid({from:guest})
			.catch((error)=>{
				assert.include(error.toString(),"Error: VM Exception","不可以被非员工调用");
			});
	});

	it ('get paid less payDuration',()=>{
		return payrool.getPaid({from:employeeOne})
			.catch((error)=>{
				assert.include(error.toString(),"Error: VM Exception","不足一个周期的时候不能调用");
			})
	}) ;

	






});