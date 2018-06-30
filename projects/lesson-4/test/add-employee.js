var Payroll = artifacts.require("./Payroll.sol");
contract('Test add employee in Payrool',function(accounts){
	console.log('Test --- begin---');
	console.log('accounts:'+accounts[0] + '--' + accounts.length);

	const owner = accounts[0];
	const employeeOne = accounts[1];
	const employeeTwo = accounts[2];
	const guest = accounts[3];


	const salaryOne = 1 ;
	const salaryTwo = 1 * 2 ;

	const totalFund = 10 ;

	it('add a normal employee by owner',function(){
		var payrool;
		return Payroll.deployed()
			.then(function(instance){
				payrool = instance;
				payrool.addFund({value:web3.toWei(totalFund, 'ether')})
			})
			.then(function(){
				payrool.addEmployee(employeeOne,salaryOne,{from:owner});
			})
			.then(function(){
				return payrool.calculateRunway();
			})
			.then(function(times){
    		    assert.equal(times.toNumber(), totalFund / salaryOne, "The runway is not correct");
			});
	});

	it ('add a employee by guest',function(){
		var payrool;
		return Payroll.deployed()
				.then(function(instance){
					payrool = instance;
					return payrool.addEmployee(employeeOne,salaryOne,{from:guest});
				})
				.catch(function(error){
					console.log(error.toString());
					assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest");
				});
	});

	it("Test addEmployee() add an exists employee", function () {
    	var payroll;
    	return Payroll.deployed().then(function (instance) {
      		payroll = instance;
      		return payroll.addEmployee(employeeOne, salaryOne, {from: owner});
    	})
    	.then(function(){
			return payroll.addEmployee(employeeOne, salaryOne, {from: owner});
    	})
    	.then(() => {
      		assert(false, "Should not be successful");
    	}).catch(error => {
      		assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() add an exists employee");
    	});
  	});
});