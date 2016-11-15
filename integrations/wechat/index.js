var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var express = require('express');
var app = express();
var msg = require('./common/msg');
var proxy = require('./common/proxy');

var myproxy = proxy("m224.baocai.com",80);
app.use(logger('dev'));
//静态路由
app.use(express.static('www'));
//代理
app.use(myproxy);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

//路由
console.log(process.env);
//处理404
app.all("*",function(req,res)
{
	msg.send404(req,res);
});

// 处理服务器错误
app.use(function(err, req, res, next) {
  console.error(err.stack);
  	msg.send500(err,req,res);
});

console.log("listen on:3001");
//app.listen(80);
app.listen(3001);
