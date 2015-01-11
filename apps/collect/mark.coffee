
AUTHORS = [
  'tremulous'
  'original'
]

INTERVENTIONS = [
  'punctuation'
  'gloss'
  'marginal gloss'
  'annotation'
  'pronounciation'
]

VALUES = [
  '.'
  '!'
  ':;'
  '.;'
  ';'
  ','
]

MARK_WIDTH = 20

module.exports = class Mark
  init: ->
    @offsetX = @model.at 'offsetX'
    @offsetX.setNull 0
    @offsetY = @model.at 'offsetY'
    @offsetY.setNull 0
    @mark = @model.at 'mark'
    @mark.setNull "certainty", 100
    @width = @model.at 'width'
    @width.set MARK_WIDTH

    @editing = @model.at 'editing'
    @editing.setNull false
    @dragging = @model.at 'dragging'
    @dragging.setNull false

    # dropdown data
    @authors = @model.at 'authors'
    @authors.set AUTHORS
    @mark.setNull 'author', AUTHORS[0]

    @interventions = @model.at 'interventions'
    @interventions.set INTERVENTIONS
    @mark.setNull 'intervention', INTERVENTIONS[0]

    @values = @model.at 'values'
    @values.set VALUES
    @mark.setNull 'value', VALUES[0]


  create: ->

  click: (evt) ->
    return unless evt
    evt.stopPropagation()
    @editing.set @mark.get "id"
    console.log "mark:", @mark.get()

  touch: (evt) ->
    return unless evt
    evt.stopPropagation()
    @editing.set @mark.get "id"
    @dragging.set true


  touching: (evt) ->
    return unless evt
    evt.stopPropagation()
    evt.preventDefault()
    if @dragging.get() and touch = evt.changedTouches[0]
      @mark.set "x", touch.pageX - @offsetX.get()
      @mark.set "y", touch.pageY - @offsetY.get()

  touched: (evt) ->
    return unless evt
    evt.stopPropagation()
    @dragging.set false

  mousedown: (evt) ->
    return unless evt
    evt.stopPropagation()
    @dragging.set true

  moving: (evt) ->
    return unless evt
    evt.stopPropagation()
    if @dragging.get()
      @mark.set "x", evt.pageX - @offsetX.get()
      @mark.set "y", evt.pageY - @offsetY.get()

  mouseup: (evt) ->
    return unless evt
    evt.stopPropagation()
    @dragging.set false


  getX: (mark, offset) ->
    return 0 unless mark
    return mark.x-@width.get()/2 + offset

  getY: (mark, offset) ->
    return 0 unless mark
    return mark.y-@width.get()/2 + offset

  color: (mark) ->
    if mark?.author == "tremulous"
      return 'yellow'
    return 'blue'

  delete: (mark, evt) ->
    return unless mark
    evt.stopPropagation()
    evt.preventDefault()
    @editing.set false
    @model.root.del "marks.#{mark.id}"

  close: (evt) ->
    evt.stopPropagation()
    @editing.set false

  editorClick: (evt) ->
    evt.stopPropagation()

  convertClick: ->
    @mark.set "converted", !@mark.get("converted")
    evt.stopPropagation()
