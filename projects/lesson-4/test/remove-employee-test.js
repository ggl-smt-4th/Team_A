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

	const totalFund = 10 ;

	it ('remove a employee by owner',function(){
		var payrool;
		return Payroll.deployed()
				.then(function(instance){
					payrool = instance;
					return payrool.addEmployee(employeeOne,salaryOne,{from:owner});
				})
				.then(function(){
					console.log('log start ---');
					return payrool.removeEmployee(employeeOne,{from:owner});
				});
				// .then(function(){
				// 	console.log('log start ---');
				// 	// return null;
				// });
				// .then(function(){
				// 	var employees = payrool.employees;
				// 	console.log(employees);
				// 	return employees;
				// })
				// .then(function(){
				// 	var employee = employees.call(employeeOne);
				// 	console.log(employee);
				// 	return employee.addr;
				// })
				// .then((employeeId)=>{
				// 	assert.equal(employeeId.toString(),employeeOne,"Remove failed");
				// });
	});


});