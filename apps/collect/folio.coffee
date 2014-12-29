# TODO:
# dragging marks
# inputing metadata
# put marks in a collection

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
    #@filter = @model.root.filter("marks", (mark) -> mark?.folioId == folioId).sort((a,b) -> b.createdAt - a.createdAt)
    #@model.ref 'marks', @filter
    @model.start 'marks', @model.scope('marks'), (marks) ->
      array = []
      for id,mark of marks
        continue unless mark
        array.push mark
      return array

    @scrolling = @model.at 'scrolling'
    @scrollStart = @model.at 'scrollStart'
    @scrollStart.set 0

    @offsetX = @model.at "offsetX"
    @offsetY = @model.at "offsetY"


  create: ->
    window.PAGE = @

    # get the "canvas" location in the page 
    # so we can draw our marks absolutely positioned
    @offsetX.set @container.offsetLeft
    @offsetY.set @container.offsetTop
    setTimeout =>
      @offsetX.set @container.offsetLeft
      @offsetY.set @container.offsetTop
    , 500


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

  touched: (evt) ->
    console.log "EVT", evt
    return unless evt
    if @scrolling.get()
      if evt.touches.length == 0
        @scrolling.set false
      return

    touch = evt.changedTouches[0]
    # we are capturing all touch at the top level svg, instead of inside it
    # can't seem to get touch events on svg from derby right now.
    # so we just account for the offsets
    x = touch.pageX - @offsetX.get()
    y = touch.pageY - @offsetY.get()
    @addMark x, y
    
  clicked: (evt) ->
    return unless evt?.pageX?
    console.log "click EVENT", evt
    x = evt.pageX - @offsetX.get()
    y = evt.pageY - @offsetY.get()
    @addMark x, y


  addMark: (x, y) ->
    width = 40 # TODO parameterize
    markId = @model.root.add "marks", {
      folioId: @model.get "folioId"
      manuscriptId: @model.get "manuscriptId"
      createdAt: +new Date()
      x: x
      y: y
      w: width
      h: width
    }
    console.log "new mark", markId


