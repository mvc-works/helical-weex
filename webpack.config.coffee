
webpack = require 'webpack'

module.exports =
  entry:
    main: './example/main.coffee'
  output:
    filename: 'build/main.js'
  module:
    rules: [
      test: /\.coffee$/, loader: 'coffee-loader'
    ]
  resolve:
    extensions: ['.coffee']
  plugins: [
    new webpack.BannerPlugin
      banner: '// { "framework": "Vanilla" }\n'
      raw: true
  ]
