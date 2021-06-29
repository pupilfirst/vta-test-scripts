const isValidPassphrase = require("./script");

describe("isValidPassphrase()", () => {
  test("empty passphrase", () => {
    expect(isValidPassphrase("")).toBe(false);
  });

  test("valid passphrase with all word length greater than 2", () => {
    expect(isValidPassphrase("my name is john doe")).toBe(true);
  });

  test("invalid passphrase with one of the word length less than 2", () => {
    expect(isValidPassphrase("i am an awesome programmer")).toBe(false);
  });

  test("passphrase is invalid without enough words", () => {
    expect(isValidPassphrase("Hello world")).toBe(false);
  });
});
