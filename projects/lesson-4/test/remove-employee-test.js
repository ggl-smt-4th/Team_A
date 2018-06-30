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

	var payrool;
	it ('remove a employee by owner',function(){
		return Payroll.deployed()
				.then(function(instance){
					payrool = instance;
					return payrool.addEmployee(employeeOne,salaryOne,{from:owner});
				})
				.then(function(){
					return payrool.removeEmployee(employeeOne,{from:owner});
				})
				.then(function(){
					return payrool.employees.call(employeeOne);
				})
				.then(function(employees){
					var employeeId = employees[0];
					assert.equal(employeeId,0,"employee remove failed");
				});
	});


	it('remove a employee by guest',
		function(){
			return payrool.removeEmployee(employeeOne,{from:guest})
			.then(()=> {
				assert(false,'Should not Successful');
			}).catch(error => {
				assert.include(error.toString(), "Error: VM Exception", "Can not remove not exists Employee");
			});
		});

	it('remove a not exists employee by owner',
		function(){
			return payrool.removeEmployee(employeeTwo,{from:owner})
			.then(()=> {
				assert(false,'Should not Successful');
			}).catch(error => {
				assert.include(error.toString(), "Error: VM Exception", "Can not remove not exists Employee");
			});
		});




});