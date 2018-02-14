const app           = require('./app');
const { sequelize } = require('models');

const PORT = process.env.PORT || 8080;

const server = app.listen(PORT, () => {
  console.log(`listening on port ${PORT}...`);
});

const handleShutdown = (err) => {
  console.log('closing server...');
  if (err) {
    console.log('something went wrong while closing:');
    console.log(err);
    process.exit(1);
  }
  server.close(async () => {
    try {
      console.log('closing DB...');
      await sequelize.close();
      console.log('DB closed.');
    } catch (e) {
      console.log(e);
    } finally {
      console.log('server closed.');
      process.exit(0);
    }
  });
};

process.on('SIGINT', handleShutdown);
process.on('SIGTERM', handleShutdown);
