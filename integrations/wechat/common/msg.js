'use strict';
var msg = exports = module.exports = {};
msg.send404 = function(req,res)
{
	res.writeHead(404,{'Content-Type':'text/html; charset=utf-8','Connection':'close'});
    res.end('Not Found');
}

msg.send500 = function(err,req,res)
{
	res.status(500).send(err.stack);
}