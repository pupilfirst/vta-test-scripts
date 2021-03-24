const createInitialsFromName = require("./script");

test("A single-worded name must return the first two letters of the word as initials", () => {
  expect(createInitialsFromName("John")).toBe("JO");
});

test("A two-worded name must return the first letter of each of the words in the name", () => {
  expect(createInitialsFromName("John Doe")).toBe("JD");
});

test("A name with more words should return the starting letter of the first and the last word as initial", () => {
  expect(createInitialsFromName("John Doe Honai")).toBe("JH");
});

test("The function should return all initials in uppercase", () => {
  expect(createInitialsFromName("john doe")).toBe("JD");
});
