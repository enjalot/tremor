derby = require 'derby'

app = module.exports = derby.createApp 'collect', __filename

global.app = app unless derby.util.isProduction

app.serverUse module, 'derby-stylus'

app.loadViews __dirname + '/views'
app.loadStyles __dirname + '/styles'

app.component "folio", require './folio'

app.get '/', (page, model) ->
  page.render 'home'

app.get '/folios/:folioId', (page, model, params, next) ->
  page.render 'folio'
