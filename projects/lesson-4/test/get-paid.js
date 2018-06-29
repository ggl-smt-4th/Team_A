var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[2];
  const salary = 2;
  const runway = 10;
  const payDuration = (30 + 1) * 86400;
  const fund = runway * salary;
  const balance = fund * 1000000000000000000;

  var payroll;

  it("Test call getPaid() by owner", () => {
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.getPaid({from: owner})
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not call getPaid() by a owner");
    });
  });

  it("Test call getPaid() by an employee", () => {
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner}); 
    }).then(() => {
      return payroll.addFund(); 
    }).then(() => {(balanceRet) =>
      assert.equal(balanceRet, balance, "The initial balance is not correct");
    }).then(() => {
      return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
    }).then(() => {
      return payroll.getPaid({from: employee})
    }).then(() => {
      return payroll.addFund(); 
    }).then(() => {(balanceRet) =>
      assert.equal(balance - balanceRet, salary * 1000000000000000000, "The balance diff is not right");
    });
  });

  it("Test call getPaid() by a non-employee", () => {
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.getPaid({from: guest})
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not call getPaid() by a non-employee");
    });
  });

  it("Test call getPaid() before duration", () => {
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.getPaid({from: employee})
    }).then((getPaidRet) => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not getPaid() before a pay duration");
    });
  });

  it("Test call getPaid() with not enough balance", () => {
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(salary - 1, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.getPaid({from: employee})
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not getPaid() with not enough balance");
    });
  });

});
