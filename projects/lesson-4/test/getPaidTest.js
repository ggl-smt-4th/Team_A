var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[2];
  const salary = 1;
  const runway = 20;
  const payDuration = (30 + 1) * 86400;
  const fund = runway * salary;
  const notEnoughFund = 1;
  const bigSalary = 2; 

  it("Test getPaid()", function () {
    var payroll;
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      if (!runwayRet.toNumber || typeof runwayRet.toNumber !== "function") {
        assert(false, "the function `calculateRunway()` should be defined as: `function calculateRunway() public view returns (uint)` | `calculateRunway()` 应定义为: `function calculateRunway() public view returns (uint)`");
      }
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
      return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
    }).then(() => {
      return payroll.getPaid({from: employee})
    }).then((getPaidRet) => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway - 1, "The runway is not correct");
    });
  });

  it("Test getPaid() repeatedly", function () {
    var payroll;
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      if (!runwayRet.toNumber || typeof runwayRet.toNumber !== "function") {
        assert(false, "the function `calculateRunway()` should be defined as: `function calculateRunway() public view returns (uint)` | `calculateRunway()` 应定义为: `function calculateRunway() public view returns (uint)`");
      }
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
      return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
    }).then(() => {
      return payroll.getPaid({from: employee})
    }).then((getPaidRet) => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway - 1, "The runway is not correct");
    }).then(() => {
        return payroll.getPaid({from: employee})
    }).then((getPaidRet) =>{
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not getPaid() repeatedly");
    });
  });

  it("Test getPaid() before duration", function () {
    var payroll;
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
      return payroll.getPaid({from: employee})
    }).then((getPaidRet) => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not getPaid() before a pay duration");
    });
  });

  it("Test getPaid() by a non-employee", function () {
    var payroll;
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
      return payroll.getPaid({from: guest})
    }).then((getPaidRet) => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not call getPaid() by a non-employee");
    });
  });

  it("Test getPaid() without enough fund", function () {
    var payroll;
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(notEnoughFund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, bigSalary, {from: owner});
    }).then(() => {
      return payroll.calculateRunway();
    }).then((runwayRet) => {
      if (!runwayRet.toNumber || typeof runwayRet.toNumber !== "function") {
        assert(false, "the function `calculateRunway()` should be defined as: `function calculateRunway() public view returns (uint)` | `calculateRunway()` 应定义为: `function calculateRunway() public view returns (uint)`");
      }
      assert.equal(runwayRet.toNumber(), 0, "Runway is wrong");
        return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
    }).then(() => {
      return payroll.getPaid({from: employee})
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Should not getPaid() when there is no enough fund");
    });
  });

});
