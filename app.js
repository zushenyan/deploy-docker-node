const express  = require('express');
const morgan   = require('morgan');
const { User } = require('./models');

const server =
  express()
    .use(morgan('dev'))
    .use('/api', async (req, res) => {
      try {
        const result  = await User.findAll();
        const payload = result.map(row => row.get());
        res.json(payload);
      } catch (e) {
        console.log(e);
        res.status(500).end();
      }
    });

module.exports = server;
