liveDbMongo = require 'livedb-mongo'
coffeeify = require 'coffeeify'

module.exports = (derby, publicDir) ->
  mongo = liveDbMongo process.env.MONGO_URL + '?auto_reconnect', {safe: true}
  derby.use require 'racer-bundle'


  store = derby.createStore db: mongo

  store.on 'bundle', (browserify) ->

    browserify.transform {global: true}, coffeeify

    pack = browserify.pack

    browserify.pack = (opts) ->
      detectTransform = opts.globalTransform.shift()
      opts.globalTransform.push detectTransform
      pack.apply this, arguments

  store

