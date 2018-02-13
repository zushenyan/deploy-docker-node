const { times } = require('lodash');
const faker     = require('faker');

faker.seed(1234);

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const users = times(10, (id) => ({
      id,
      name:      faker.name.findName(),
      createdAt: new Date(1234),
      updatedAt: new Date(1234),
    }));
    await queryInterface.bulkInsert('Users', users);
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('Users', null, {});
  }
};
