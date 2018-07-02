var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[2];
  const salary = 1;

  var payroll;

  beforeEach("Setup contract for each test cases", () => {
    return Payroll.new().then(instance => {
      payroll = instance;
      return payroll.addEmployee(employee, salary, {from: owner});
    });
  });

  it("Test call removeEmployee() by owner", () => {
    // Remove employee
    return payroll.removeEmployee(employee, {from: owner});
  });

  it("Test call removeEmployee() by employee himself", () => {
    return payroll.removeEmployee(employee, {from: employee}).then(() => {
      assert(false, "Should not be successful");
      }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by employee himself");
      });
    });

  it("Test call removeEmployee() by a non-employee", () => {
    return payroll.removeEmployee(employee, {from: guest}).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by a non-employee");
    });
  });

  it("Test call removeEmployee() repeatedly", () => {
    return payroll.removeEmployee(employee, {from: owner}).then(() => {
      return payroll.removeEmployee(employee, {from: owner});
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
        assert.include(error.toString(), "Error: VM Exception", "Can not remove a specific employee twice");
    });
  });

  it("Test call removeEmployee() with non-employee input", () => {
    return payroll.removeEmployee(guest, {from: owner}).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
        assert.include(error.toString(), "Error: VM Exception", "Can not remove a non-employee");
    });
  });

});
