var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0]
  const employee = accounts[1]
  const guest = accounts[5]
  const salray = 1;

  it("Test call updateEmployeeAddress() by owner", function () {
    var payroll;
    return Payroll.deployed().then(instance => {
      payroll = instance;
      return payroll.updateEmployeeAddress(employee, { from: owner });
    });
  });

  it("Test updateEmployeeSalary() by owner", function () {
    var payroll;
    return Payroll.deployed().then(function (instance) {
      payroll = instance;
      return payroll.updateEmployeeSalary(salray + 1, { from: owner });
    }).catch(error => {
      assert.include(error.toString(), "invalid opcode", error.toString());
    });
  });

  it("Test updateEmployeeAddress() by guest", function () {
    var payroll;
    return Payroll.deployed().then(function (instance) {
      payroll = instance;
      return payroll.updateEmployeeAddress(employee, { from: guest });
    }).then(() => {
      assert(false, "Should not be successful");
    }).catch(error => {
      assert.include(error.toString(), "Error: VM Exception while processing transaction: revert", "Can not call addEmployee() by who is not owner");
    });
  });
});
