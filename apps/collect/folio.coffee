app = require './index'

module.exports = class Folio
  init: ->
    folioId = @model.root.get "$render.params.folioId"
    manuscriptId = @model.root.get "$render.params.manuscriptId"
    @model.set "folioId", folioId
    @model.set "manuscriptId", manuscriptId

    # get a local reference to this folio
    @folio = @model.at "folio"
    @model.ref "folio", @model.scope("folios.#{folioId}")

    @model.set 'test', 0
    @marks = @model.at 'marks'
    @marks.setNull []
    @scrolling = @model.at 'scrolling'
    @scrollStart = @model.at 'scrollStart'
    @scrollStart.set 0

  create: ->
    window.PAGE = @

  clear: ->
    @marks.set []
    @model.set "test", 0

  touch: ($evt) ->
    @scrollStart.set +new Date
  touching: ($evt) ->
    # we only indicate that the user is scrolling if they've been moving
    # for more than 100 milliseconds
    if +new Date() - @scrollStart.get() > 100
      @scrolling.set true

  touched: ($evt) ->
    console.log "EVT", $evt
    return unless $evt
    if @scrolling.get()
      if $evt.touches.length == 0
        @scrolling.set false
      return

    touch = $evt.changedTouches[0]
    width = 40

    @model.increment "test"
    # we are capturing all touch at the top level svg, instead of inside it
    # can't seem to get touch events on svg from derby right now.
    # so we just account for the offsets
    @model.push "marks", {
      x: touch.pageX# - @container.offsetLeft
      y: touch.pageY# - @container.offsetTop 
      w: 40
      h: 40
    }

  clicked: ($evt) ->
    #console.log "MOUSE", $evt
