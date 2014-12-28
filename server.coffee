async = require 'async'
derby = require 'derby'

http  = require 'http'
chalk = require 'chalk'

publicDir = process.cwd() + '/public'

derby.run () ->
  require './server/config'

  apps = [
    require './apps/collect'
    # <end of app list> - don't remove this comment
  ]

  express = require './server/express'
  store = require('./server/store')(derby, publicDir)

  error = require './server/error'

  {expressApp, upgrade} = express store, apps, error, publicDir

  server = http.createServer expressApp

  server.on 'upgrade', upgrade

  bundleApp = (app, cb) ->
    app.writeScripts store, publicDir, {extensions: ['.coffee']}, (err) ->
      if err
        console.log "Bundle don't created:",
            chalk.red(app.name), ', error:', err
      else
        console.log 'Bundle created:', chalk.blue(app.name)

      cb();

  async.each apps, bundleApp, () -> server.listen process.env.PORT, () ->
    console.log '%d listening. Go to: http://localhost:%d/',
      process.pid, process.env.PORT