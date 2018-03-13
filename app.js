const express             = require('express');
const morgan              = require('morgan');
const os                  = require('os');
const { sequelize, User } = require('./models');

const server =
  express()
    .use(morgan('dev'))
    .get('/', async (req, res) => {
      try {
        const result  = await User.findAll();
        const data    = result.map(row => row.get());
        const payload = {
          data,
          host: os.hostname(),
        };
        res.json(payload);
      } catch (e) {
        console.log(e);
        res.status(500).end();
      }
    })
    .get('/db', async (req, res) => {
      try {
        await sequelize.authenticate();
        res.json({ msg: 'db connection ok' });
      } catch (e) {
        res.json({ msg: 'db failed' });
        console.log(e);
      }
    });

module.exports = server;
