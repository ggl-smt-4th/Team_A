var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
  const owner = accounts[0];
  const employee = accounts[1];
  const guest = accounts[5];
  const salary = 1;

  // test idendity of contract caller, by owner
  it("Test call addEmployee() by owner", async function () {
    var payroll = await Payroll.deployed();
    await payroll.addEmployee.call(employee, salary, {from: owner});
    const count = await payroll.totalEmployee.call()
    assert.equal(parseInt(count), 1, "Employee number is not updated correctly");
  });

  // test idendity of contract caller, by guest
  it("Test addEmployee() by guest", async function () {
    var payroll = await Payroll.deployed();
    try {
      await payroll.addEmployee(employee, salary, {from: guest});
    } catch(error) {
      assert(false, "Should not be successful");
      assert.include(error.toString(), "Error: VM Exception", "Can not call addEmployee() by guest");
    }

    throw new Error("You should not see this message!");
  });

  // test adding an employee with negative salary
  it("Test call addEmployee() with negative salary", async function () {
    var payroll = await Payroll.deployed();;
    try {
      await payroll.addEmployee(employee, -salary, {from: owner});
    } catch(error) {
      assert.fail;
      assert.include(error.toString(), "Error: VM Exception", "Negative salary can not be accepted!");
    }

    throw new Error("You should not see this message!");
  });

});
