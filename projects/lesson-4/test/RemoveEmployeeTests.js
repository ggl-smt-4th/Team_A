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
            return payroll.addEmployee(employee, salary, {
                from: owner
            });
        });
    });

    it("Test removeEmployee() by owner", () => {
        // Remove employee
        return payroll.removeEmployee(employee, {
            from: owner
        });
    });

    it("Test removeEmployee() by employee himself", () => {
        return payroll.removeEmployee(employee, {
            from: employee
        }).then(() => {
            assert(false, "Should not be successful");
        }).catch(error => {
            assert.include(error.toString(), "Error: VM Exception", "Can not call removeEmployee() by employee himself");
        });
    });

    it("Test removeEmployee() by a guest", () => {
        return payroll.removeEmployee(employee, {
            from: guest
        }).then(() => {
            assert(false, "Should not be successful");
        }).catch(error => {
            assert.include(error.toString(), "Error: VM Exception", "Can not call removeEmployee() by a guest");
        });
    });

    it("Test removeEmployee() repeatedly", () => {
        return payroll.removeEmployee(employee, {
            from: owner
        }).then(() => {
            return payroll.removeEmployee(employee, {
                from: owner
            });
        }).then(() => {
            assert(false, "Should not be successful");
        }).catch(error => {
            assert.include(error.toString(), "Error: VM Exception", "Can not remove an employee twice");
        });
    });

    it("Test removeEmployee() with non-employee input", () => {
        return payroll.removeEmployee(guest, {
            from: owner
        }).then(() => {
            assert(false, "Should not be successful");
        }).catch(error => {
            assert.include(error.toString(), "Error: VM Exception", "Can not remove a guest");
        });
    });

});