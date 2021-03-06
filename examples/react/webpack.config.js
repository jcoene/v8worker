var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: {
    'server.js': path.resolve(__dirname, 'server.js')
  },
  output: {
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      {
        test: /.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx']
  }
};
