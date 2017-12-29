const { environment } = require('@rails/webpacker')

// add stylus loader
environment.loaders.append('stylus', {test: /\.(styl)$/, use: [{loader: 'style-loader'}, {loader: 'css-loader'}, {loader: 'stylus-loader'}]}) //.get('css').use.push({loader: 'stylus-loader'})
environment.loaders.get('file').exclude = /\.(js|jsx|coffee|ts|tsx|vue|elm|scss|sass|css|styl|html|json)?(\.erb)?$/

module.exports = environment
