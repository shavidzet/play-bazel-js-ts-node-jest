const path = require('path');

module.exports = {
  testEnvironment: 'node',
  haste: {
    enableSymlinks: true,
  },
  reporters: ['default', './jest-reporter'],
  // explicitly specify the path to babel.config.js relative to jest.config.js so
  // jest can find it even when jest.config.js is not in the root folder of the workspace
  transform: {}
};
