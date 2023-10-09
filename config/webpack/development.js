process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
// environment.config.set('output.publicPath', '/myapp/packs')
// console.log(environment.config.output)

module.exports = environment.toWebpackConfig()
