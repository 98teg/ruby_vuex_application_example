const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPLugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const DuplicatePackageCheckerPlugin = require('duplicate-package-checker-webpack-plugin');

// Entorno Base
module.exports = env => {
  config = {
    entry: './src/js/main.js',
    output: {
      filename: 'application.js',
      sourceMapFilename: 'application.map'
    },
    module: {
      rules: [
        {
          test: /\.js$/, // compile javascript files
          include: [
            path.resolve(__dirname, 'src')
          ],
          loader: 'babel-loader',
          query: {
            presets: [
              ['@babel/preset-env', {
                targets: {
                  safari: 10,
                  ie: 11,
                  chrome: 64,
                  firefox: 58
                },
                useBuiltIns: 'usage',
                corejs: 3
              }]
            ]
          }
        },
        {
          test: /\.(jpe?g|png|gif|svg|woff2?|ttf|eot)$/i, // compile scss files
          include: [
            path.resolve(__dirname, 'src/assets'),
            path.resolve(__dirname, 'src/scss/assets')
          ],
          loader: 'file-loader?name=assets/[hash].[ext]'
        },
        {
          test: /\.pug$/, // compile .pug templates
          include: [
            path.resolve(__dirname, 'src/js')
          ],
          loader: 'pug-loader'
        }
      ]
    },
    resolve: {
      modules: [
        path.resolve('./src'),
        'node_modules'
      ],
      alias: { // make vue global accesible
        'vue$': 'vue/dist/vue.common.js'
      }
    },
    plugins: [
      new webpack.DefinePlugin({
        API_HOST: JSON.stringify(process.env.API_HOST) || "'http://localhost:3000'",
        ENV: JSON.stringify(env),
        WS_HOST: JSON.stringify(process.env.WS_HOST) || "'ws://localhost:3000/cable'"
      }),
      new HtmlWebpackPLugin({ // compile index.ejs and inject js
        template: 'src/index.ejs'
      }),
      new webpack.ProvidePlugin({
        Vue: 'vue',
        API: [path.resolve(__dirname, 'src/js/services/api.js'), 'default']
      })
    ],
    devtool: 'source-map'

  };

  // Entorno de Desarrollo
  if (env === 'development') {
    config.output.path = path.resolve(__dirname, 'dev');

    config.module.rules.push({
      test: /\.scss$/, // compile scss files
      include: [
        path.resolve(__dirname, 'src/scss')
      ],
      loaders: ['style-loader', 'css-loader', 'sass-loader']
    });

    config.devServer = {
      disableHostCheck: true,
      contentBase: path.join(__dirname, 'dev'),
      port: process.env.PORT || 8000
    };

    config.plugins.push(new CleanWebpackPlugin(['dev']));
    config.plugins.push(new DuplicatePackageCheckerPlugin());
  }
  // Entorno de Test
  else if (env === 'test') {
    config.output.path = path.resolve(__dirname, '../public');

    config.module.rules.push({
      test: /\.scss$/, // compile scss files
      include: [
        path.resolve(__dirname, 'src/scss')
      ],
      use: [
        MiniCssExtractPlugin.loader,
        'css-loader',
        'sass-loader'
      ]
    });

    config.plugins.push(new MiniCssExtractPlugin({filename: 'application.css'}));
  }
  // Entorno de Producción
  else {
    config.output.path = path.resolve(__dirname, 'dist');
    config.output.filename = 'application.[hash].js';

    config.module.rules.push({
      test: /\.scss$/, // compile scss files
      include: [
        path.resolve(__dirname, 'src/scss')
      ],
      use: [
        MiniCssExtractPlugin.loader,
        'css-loader',
        'sass-loader'
      ]
    });

    config.plugins.push(new CleanWebpackPlugin(['dist']));
    config.plugins.push(new MiniCssExtractPlugin({filename: 'application.[hash].css'}));
  }

  return config;
};
