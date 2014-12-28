app = require './index'

module.exports = class Manuscript
  init: ->
    manuscriptId = @model.root.get "$render.params.manuscriptId"
    @model.set "manuscriptId", manuscriptId
    @filter = @model.root.filter "folios", (folio) ->
      folio.manuscriptId == manuscriptId
    @model.ref "folios", @filter

  create: ->
    window.PAGE = @