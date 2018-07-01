var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee_1 = accounts[1];
  const employee_2 = accounts[2];
  const salary = 10;

  it("Test call addEmployee() by owner", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee_1, salary, {from: owner});
    });
  });

  it("Twice call addEmployee() by owner", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee_1, salary, {from: owner});
    }).then(() => {
      return payroll.addEmployee(employee_1, salary, {from: owner});
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Twice call can not be accepted!");
    });
  });

  it("Test call addEmployee() with error salary", function () {
    var payroll;
    var salary_error = -10;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee_1, salary_error, {from: owner});
    }).then(() => {
      assert(false,"Should not be successful");
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "error salary can not be accepted!");
    });
  });

  it("Test addEmployee() by itself", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(employee_1, salary, {from: employee_1});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by itself");
    });
  });

  it("Test addEmployee() by guest(employee_2)", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(employee_1, salary, {from: employee_2});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest(employee_2)");
    });
  });
});
