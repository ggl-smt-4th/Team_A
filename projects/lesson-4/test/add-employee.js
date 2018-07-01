var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[5];
  const salary = 1;

  // add test to verify the total employee number and total salary update.
  it("Test call addEmployee() by owner", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      assert(payroll.totalEmployee(), 1, "Total employee number is not updated correctly.");
      assert(payroll.totalSalary(), salary, "Total salary is not updated correctly.");
    });
  });

  // test to verify "addEmployee()" should not be called by guest.
  it("Test addEmployee() by guest", function () {
    var payroll;
    return Payroll.new().then(function (instance) {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: guest});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest.");
    });
  });

  // test to disallow negative employee salary.
  it("Test call addEmployee() with negative salary", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, -salary, {from: owner});
    }).then(assert.fail).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    });
  });

  // test to disallow adding an existing employee.
  it("Test call addEmployee() with an existing employee", function () {
    var payroll;
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      return payroll.addEmployee(employee, salary, {from: owner});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Can not add an existing employee.");
    });
  });

});
