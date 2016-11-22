var webpack = require('webpack');
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var path = require('path');

module.exports = {
    devtool: 'source-map',
    devServer: {
        port: 3000,
        historyApiFallback: {
            index: 'index.html'
        }
    },
    entry: {
        home: __dirname + '/home.js',
        common: ['react', 'redux', 'react-redux', 'material-ui', 'react-dom', 'jquery' ,'redux-thunk', 'redux-logger'],
        style: path.resolve(__dirname, "../../../css/app.less")
    },
    output: {
        path: __dirname + "/react",
        publicPath: "/react/",
        filename : "bundle.[name].js",
        chunkFilename: "[id].chunk.js"
    },
    plugins: [
        new ExtractTextPlugin("bundle.[name].css")
    ],
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                loader: "babel-loader",
                exclude: /node_modules/,
                query: {
                    presets: ['react', 'es2015', 'es2016-node5', 'stage-0'],
                    plugins: ['transform-runtime']
                }
            },
            {
                test: /\.less$/,
                loader: ExtractTextPlugin.extract('style-loader', 'css!less?indentedSyntax=true&sourceMap=true')
            },
            {
                test: /\.css$/,
                loader: ExtractTextPlugin.extract("style-loader", "css-loader")
            }, 
            {
                test: /\.json$/,
                loader: 'json'
            },
            {
                test: /\.(jpe?g|gif|png|eot|svg|woff|woff2|ttf)([\?]?.*)$/,
                loaders: ['url-loader']
            },
        ],
    },
    resolveLoader: {
        root: path.resolve(__dirname, '../../../../node_modules'),
    },
}
