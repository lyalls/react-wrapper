module.exports = {
    devtool: 'source-map',
    devServer: {
        port: 3000,
        historyApiFallback: {
            index: 'index.html'
        }
    },
    entry: {
        index: __dirname + "/src/apps/mobile/index.js",
        common: ['react', 'redux', 'react-redux', 'material-ui', 'react-dom', 'jquery' ,'redux-thunk', 'redux-logger'],
        css: __dirname + "/src/css/app.less"
    },
    output: {
        path: __dirname + "/built",
        publicPath: "/built/",
        filename : "bundle.[name].js",
        chunkFilename: "[id].chunk.js"
    },
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
                loaders: ['style', 'css', 'less']
            },
            {
                test: /\.css$/,
                loaders: ['style', 'css']
            }, 
            {
                test: /\.json$/,
                loader: 'json'
            },
            {
                test: /\.(jpe?g|gif|png|eot|svg|woff|woff2|ttf)$/,
                loaders: ['file']
            }
        ]
    }
}