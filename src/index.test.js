const { greeting } = require('./index.js');

test('it should work', () => {
  expect(greeting('everyone')).toBe('Hello everyone');
});