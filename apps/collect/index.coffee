derby = require 'derby'

app = module.exports = derby.createApp 'collect', __filename

global.app = app unless derby.util.isProduction

app.serverUse module, 'derby-stylus'

app.loadViews __dirname + '/views'
app.loadStyles __dirname + '/styles'

app.component "home", require './home'
app.component "manuscript", require './manuscript'
app.component "folio", require './folio'
app.component "mark", require './mark'

app.get '/', (page, model) ->
  # grab all the manuscripts
  model.subscribe "manuscripts", ->
    page.render 'home'

app.get '/folios/:manuscriptId', (page, model, params, next) ->
  # grab all the folios for the manuscript
  folioQuery = model.query "folios", {manuscriptId: params.manuscriptId}
  model.fetch folioQuery, "manuscripts.#{params.manuscriptId}", (err) ->
    console.log err if err
    page.render 'manuscript'

app.get '/folios/:manuscriptId/:index/:side', (page, model, params, next) ->
  # grab the specific folio
  folioQuery = model.query "folios", {manuscriptId: params.manuscriptId, index: +params.index, side: params.side}
  markQuery = model.query "marks", {folioId: params.folioId, manuscriptId: params.manuscriptId0}
  model.subscribe folioQuery, markQuery, "manuscripts.#{params.manuscriptId}", (err) ->
    console.log err if err
    page.render 'folio'

app.on 'ready', (page) ->
  window.MODEL = page.model

