let Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', (accounts) => {
  const owner = accounts[0];
  const salary = 1;

  let payroll;

  beforeEach("Setup contract for each test cases", () => {
    return Payroll.new().then(instance => {
      payroll = instance;
    });
  });

  let gasUsed = -1;
  it("Test gas consumption", async () => {
    for (let i = 1; i < 10; ++i) {
      await payroll.addEmployee(accounts[i], salary, {from: owner});

      // TODO: check right or not
      const result = await payroll.calculateRunway.estimateGas();
      if (i == 1) {
        gasUsed = result;
      } else {
        assert(gasUsed == result, "Gas consumption for each calculateRunway() transaction should not remain the same");
      }
    }
  });
});
