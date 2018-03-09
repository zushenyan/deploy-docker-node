const app           = require('./app');
const { sequelize } = require('models');

const PORT = process.env.PORT || 8080;

let server;

server = app.listen(PORT, () => {
  console.log(`listening on port ${PORT}...`);
});

const handleShutdown = (err) => {
  console.log('closing server...');
  if (err) {
    console.log('something went wrong while closing:');
    console.log(err);
    process.exit(1);
  }
  if (server) {
    server.close(() => console.log('server closed.'));
  }
  (async () => {
    try {
      console.log('closing DB...');
      await sequelize.close();
      console.log('DB closed.');
    } catch (e) {
      console.log(e);
    } finally {
      process.exit(0);
    }
  })();
};

process.on('SIGINT', handleShutdown);
process.on('SIGTERM', handleShutdown);
