let Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  const employee = accounts[1];
  const employee2 = accounts[5];
  const guest = accounts[3];
  const salary = 1;

  let payroll;

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

  it("Test call removeEmployee() by owner with wrong address", () => {
    // Remove employee
    return payroll.removeEmployee(employee2, {from: owner}).then(function () {
        assert(false)
    }).catch(function (error) {
        assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() with wrong address");
    });
  });

  it("Test call removeEmployee() by guest", () => {
    return payroll.removeEmployee(employee, {from: guest}).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception", "Cannot call removeEmployee() by guest");
    });
  });
});