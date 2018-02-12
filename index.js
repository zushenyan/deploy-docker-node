const server        = require('./server');
// const { sequelize } = require('models');

const PORT = process.env.PORT || 8080;

server.listen(PORT, () => {
  console.log(`listening on port ${PORT}...`);
});

const handleShutdown = (err) => {
  if (err) console.log(err);
  console.log('server is closing...');
  server.close(() => {
    console.log('server closed...');
  });
};

process.on('SIGINT', handleShutdown);
process.on('SIGTERM', handleShutdown);
