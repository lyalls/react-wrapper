var config = require('./webpack.config.js');
delete config.devServer;
module.exports = config;
