var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var express = require('express');
var app = express();
var msg = require('./server/msg');
var proxy = require('./server/proxy');

var myproxy = proxy("m224.baocai.com",80);
app.use(logger('dev'));

// Webpack Hot Compiler
var webpack = require('webpack');
var webpackConfig = require('./webpack.config');
delete webpackConfig.devServer;
for(var item in webpackConfig.entry){
    if(typeof webpackConfig.entry[item] === 'string'){
        webpackConfig.entry[item] = [webpackConfig.entry[item], 'webpack-hot-middleware/client'];
    }else{
        webpackConfig.entry[item].push('webpack-hot-middleware/client');
    }
}
if(webpackConfig.plugins === undefined) webpackConfig.plugins = [];
Array.prototype.push.apply(webpackConfig.plugins, [
    // Webpack 2.0 fixed this mispelling 
    new webpack.optimize.OccurrenceOrderPlugin(), 
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
]);

console.log(webpackConfig);
var compiler = webpack(webpackConfig);
app.use(require("webpack-dev-middleware")(compiler, {
    noInfo: true, publicPath: webpackConfig.output.publicPath
}));
app.use(require("webpack-hot-middleware")(compiler));

app.set('views', __dirname + '/');
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'ejs');
app.get('/', function(res, req){
    req.status(200).render('index.html');
});


//静态路由
//app.use(express.static('www'));
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

console.log("listen on:2999");
//app.listen(80);
app.listen(2999);
