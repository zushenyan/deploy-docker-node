const { times }  = require('lodash');
const supertest  = require('supertest');
const os         = require('os');
const { expect } = require('chai');

const server        = require('app.js');
const faker         = require('utils/faker.js');
const { sequelize } = require('models');

const request        = supertest(server);
const queryInterface = sequelize.getQueryInterface();

describe('testing API', () => {
  let users;

  before(async () => {
    await sequelize.sync({ force: true });
    users = times(10, (id) => ({
      id,
      name: faker.name.findName(),
      createdAt: new Date(123),
      updatedAt: new Date(123),
    }));
    await queryInterface.bulkInsert("Users", users);
  });

  after(async () => {
    await queryInterface.bulkDelete("Users", null, {});
  });

  describe('/api', () => {
    it('should return fixed data', async () => {
      await request
        .get('/')
        .expect(200)
        .then((res) => {
          const expectation = {
            data: users.map((data) => ({
              ...data,
              createdAt: data.createdAt.toISOString(),
              updatedAt: data.updatedAt.toISOString()
            })),
            host: os.hostname()
          };
          expect(res.body).to.eql(expectation);
        });
    });
  });
});
