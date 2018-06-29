var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
    const owner = accounts[0];
    const employee = accounts[1];
    const guest = accounts[2];
    const salary = 1;

    var payroll;

  it("Test call addEmployee() by owner", () => {   
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  it("Test call addEmployee() by employee himself", () => {
    return Payroll.new().then((instance) => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: employee});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by employee himself");
    });
  });

  it("Test call addEmployee() by a non-employee", () => {
    return Payroll.new().then((instance) => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: guest});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by a non-employee");
    });
  });

  it("Test call addEmployee() repeatedly", () => {
    return Payroll.new().then((instance) => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
        assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not add a specific employee twice");
    });
  });

  it("Test call addEmployee() with negative salary", function () {
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, -salary, {from: owner});
    }).then(() => {
        assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    });
  });
});
