const { times }     = require('lodash');
const supertest     = require('supertest');

const server        = require('server.js');
const faker         = require('utils/faker.js');
const { sequelize } = require('models');

const request        = supertest(server);
const queryInterface = sequelize.getQueryInterface();

describe('testing API', () => {
  beforeAll(async () => {
    await sequelize.sync({ force: true });
    const users = times(10, (id) => ({
      id,
      name: faker.name.findName(),
      createdAt: new Date(),
      updatedAt: new Date(),
    }));
    queryInterface.bulkInsert("Users", users);
  });

  afterAll(async () => {
    queryInterface.bulkDelete("Users", null, {})
    await sequelize.close();
    server.close();
  });

  describe('/api', () => {
    it('should return fixed data', async () => {
      await request
        .get('/api')
        .expect(200)
        .then((res) => {
          expect(res.body).toMatchSnapshot();
        });
    });
  });
});
