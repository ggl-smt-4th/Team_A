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
	
	var payroll;
	
	it('add a normal employee by owner',function(){	
		return Payroll.deployed()
			.then(function(instance){
				payroll = instance;
				payroll.addFund({value:web3.toWei(totalFund, 'ether')})
			}).then(function(){
				payroll.addEmployee(employeeOne,salaryOne,{from:owner});
			}).then(function(){
				return payroll.calculateRunway();
			}).then(function(times){
    		    assert.equal(times.toNumber(), totalFund / salaryOne, "The runway is not correct");
			});
	});

	it ('add a employee by guest',function(){
		return payroll.addEmployee(employeeTwo,salaryOne,{from:guest})
			.then(()=> {
				assert(false,'Should not successful');
			}).catch(function(error){
				assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest");
			});
	});

	it("Test addEmployee() add an exists employee", function () {
		return payroll.addEmployee(employeeOne, salaryOne, {from: owner})
			.then(() => {
      			assert(false, "Should not be successful");
    		}).then(()=> {
				assert(false,'Should not successful');
			}).catch(error => {
      			assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() add an exists employee");
    		});
    	
  	});
});