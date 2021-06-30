const isValidPassphrase = require("./script");

describe("isValidPassphrase()", () => {
  test("An empty passphrase returns false", () => {
    expect(isValidPassphrase("")).toBe(false);
  });

  test("A valid passphrase with all word length greater than 2 returns true", () => {
    expect(isValidPassphrase("my name is john doe")).toBe(true);
  });

  test("An invalid passphrase with one of the word length less than 2 returns false", () => {
    expect(isValidPassphrase("i am an awesome programmer")).toBe(false);
  });

  test("A passphrase without enough words returns false", () => {
    expect(isValidPassphrase("Hello world")).toBe(false);
  });
});
