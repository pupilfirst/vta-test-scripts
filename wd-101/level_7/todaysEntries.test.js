const todaysEntries = require("./script");

test("Should return names of the entries with todays date ", () => {
  input = [
    { name: "Johny", date: "2021-01-21T02:53:42+05:30" },
    { name: "Sugar", date: Date().toISOString() },
    { name: "Sun", date: Date().toISOString() },
  ];

  expect(createInitialsFromName(input)).toBe("Sugar, Sun");
});

test("Should return an empty string if there are no entries for today", () => {
  input = [
    { name: "Johny", date: "2021-01-21T02:53:42+05:30" },
    { name: "Sugar", date: "2021-01-21T02:53:42+05:30" },
  ];

  expect(createInitialsFromName(input)).toBe("");
});
