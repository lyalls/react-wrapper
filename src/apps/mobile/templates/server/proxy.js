var express = require('express');
var http = require('http');

/**
 * Expose `proxy`.
 */

exports = module.exports = proxy;
console.log('init proxy');


function proxy(address,port,basePath)
{
	var app = express();
    app.basePath = basePath?basePath:"";
    if(address)
    {
        app.proxyaddress = address;
    }
    else
    {
	   app.proxyaddress = 'm224.baocai.com';
    }

    if(!port)
    {
        port = 80;
    }

	app.proxy = function(req,res)
    {
        var headers = {};
        for(var i in req.headers)
        {
            if(i != 'host')
            {
                headers[i] = req.headers[i];
            }else{
                console.log('replacing original host:', req.headers[i], 'to proxy host:', app.proxyaddress);
            }
        }
        console.log("path:"+app.basePath + req.originalUrl);
    	var op = {
    		hostname:app.proxyaddress,
    		port:port,
    		path: app.basePath + req.originalUrl,
    		method:req.method,
    		'headers':headers
    	};

    	var newreq = http.request(op,function(res1)
    	{

            console.log("reponse headers:");
            console.log(res1.headers);
                console.log('');
            res.writeHead(res1.statusCode,res1.headers);
            res1.pipe(res);
    		res1.on('end',function()
    		{
    			res.end();
    		});
    		res1.on('error',function()
    		{
    			res.statusCode = 404;
    			res.write('the page not found');
    			res.end();

    		});
    	});
        newreq.on('error',function()
        {
            res.statusCode = 404;
                res.write('the page not found');
                res.end();
        })
        req.pipe(newreq);

        req.on('end',function()
        {
            newreq.end();
        });

    };

    app.all('*',function(req,res)
    {
        app.proxy(req,res);
        if(req.method != 'POST' && req.method != 'PUT')
        {
            req.emit('end');
        }
    });

    //添加代理方法

	return app;
}
console.log('init proxy done');
console.log('');