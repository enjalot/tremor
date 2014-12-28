app = require './index'

module.exports = class Home
  init: ->
    @filter = @model.root.filter "manuscripts", -> true
    @model.ref "manis", @filter

  create: ->
    window.PAGE = @
