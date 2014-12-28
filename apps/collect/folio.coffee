app = require './index'

module.exports = class Folio
  init: ->
    @model.set 'test', 0
    @marks = @model.at 'marks'
    @marks.setNull []
    @scrolling = @model.at 'scrolling'
    @scrollStart = @model.at 'scrollStart'
    @scrollStart.set 0

  create: ->

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
      x: touch.pageX - @canvas.offsetLeft
      y: touch.pageY - @canvas.offsetTop 
      w: 40
      h: 40
    }
