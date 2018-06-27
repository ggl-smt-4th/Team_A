var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const employee2 = accounts[2];
  const guest = accounts[5];
  const salary = 1;
  const runway = 20;
  const fund = runway * salary;
  const payDuration = (30 + 1) * 86400;

  let payroll;

  beforeEach("Setup contract for each test cases", () => {
    return Payroll.new.call(owner, {from: owner, value: web3.toWei(fund, 'ether')}).then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  it("Test updateEmployee", () => {
    return payroll.calculateRunway().then(runwayRet => {
      if (!runwayRet.toNumber || typeof runwayRet.toNumber !== "function") {
        assert(false, "the function `calculateRunway()` should be defined as: `function calculateRunway() public view returns (uint)` | `calculateRunway()` 应定义为: `function calculateRunway() public view returns (uint)`");
      }
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
    }).then(() => {
      return payroll.updateEmployee(employee, salary * 2, {from: owner})
    }).then(() => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway / 2, "The runway is not correct");
    });
  });

  it("Test changePaymentAddress()", function () {
    return payroll.calculateRunway().then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
    }).then(() => {
      return payroll.changePaymentAddress(employee, employee2, {from: owner});
    }).then(() => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway, "Runway is wrong");
      return web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [payDuration], id: 0});
    }).then(() => {
      return payroll.getPaid({from: employee2})
    }).then((getPaidRet) => {
      return payroll.calculateRunway();
    }).then(runwayRet => {
      assert.equal(runwayRet.toNumber(), runway - 1, "The runway wrong");
    });
  });

})
;
