
AUTHORS = [
  'tremulous'
  'original'
]

INTERVENTIONS = [
  'punctuation'
  'word division'
  'superscript vowels'
  'interlinear gloss'
  'marginal gloss'
  'annotation'
]

VALUES = {
  'punctuation': [
    '.'
    '!'
    ':;'
    '.;'
    ';'
    ','
  ],
  'word division': [
    '⌿'
    '⡆'
    '⡇'
  ],
  'superscript vowels': [
    'æ⇨a'
    'æ⇨e'
    'æ⇨o'
    'æ⇨u'
    'a⇨e'
    'a⇨o'
    'e⇨i'
    'e⇨eu'
    'e⇨u'
    'e⇨o'
    'e⇨a'
    'e⇨æ'
    'eo⇨i'
    'eo⇨u'
    'ge⇨i'
    'g⇨i'
    'g⇨þ'
    'g⇨w'
    'g⇨ȝ'
    'i⇨e'
    'i⇨a'
    'i⇨o'
    'i⇨u'
    'i⇨y'
    'i⇨eo'
    'o⇨e'
    'o⇨u'
    'y⇨e'
    'y⇨u'
    'y⇨a'
    'y⇨i'
    'y⇨o'
    'æg⇨ei'
    'ng⇨ncg'
    'c⇨k'
    'c⇨ch'
    'h⇨0'
    'd⇨ð'
    's⇨r'
    'for⇨mis'
    'fram⇨of'
  ]
  'interlinear gloss': ['']
  'marginal gloss': ['']
  'annotation': ['']
}

MARK_WIDTH = 20

module.exports = class Mark
  init: ->
    @offsetX = @model.at 'offsetX'
    @offsetX.setNull 0
    @offsetY = @model.at 'offsetY'
    @offsetY.setNull 0
    @mark = @model.at 'mark'
    @mark.setNull "certainty", 100
    #@width = @model.at 'width'
    #@width.set MARK_WIDTH
    @mark.setNull 'width', MARK_WIDTH
    @mark.setNull 'height', MARK_WIDTH

    @editing = @model.at 'editing'
    @editing.setNull false
    @dragging = @model.at 'dragging'
    @dragging.setNull false
    @resizeDragging = @model.at 'resizeDragging'
    @resizeDragging.setNull false

    # dropdown data
    @authors = @model.at 'authors'
    @authors.set AUTHORS
    @mark.setNull 'author', AUTHORS[0]

    @interventions = @model.at 'interventions'
    @interventions.set INTERVENTIONS
    @mark.setNull 'intervention', INTERVENTIONS[0]

    @model.start "values", "mark.intervention", (interventionType) ->
      return VALUES[interventionType]
    @values = @model.at 'values'
    @values.on "all", =>
      @mark.set 'value', @values.get 0
    @mark.setNull 'value', @values.get 0

    sizeChange = =>
      intervention = @mark.get 'intervention'
      if intervention in ['interlinear gloss', 'marginal gloss', 'annotation']
        @mark.set 'width', MARK_WIDTH * 3
        @mark.set 'height', MARK_WIDTH * 1.5
      else if intervention == 'superscript vowels'
        @mark.set 'width', MARK_WIDTH * 1.5
        @mark.set 'height', MARK_WIDTH * 2
      else
        @mark.set 'width', MARK_WIDTH
        @mark.set 'height', MARK_WIDTH

    @mark.on "change", "intervention", sizeChange
    sizeChange()


  create: ->
    document.addEventListener 'mousemove', =>
      @resizeMoving.apply(@, arguments)
      @moving.apply(@, arguments)

    document.addEventListener 'mouseup', =>
      if @dragging.get()
        @dragging.set false
      if @resizeDragging.get()
        @resizeDragging.set false


  getX: (mark, offset) ->
    return 0 unless mark
    return mark.x-mark.width/2 + offset

  getY: (mark, offset) ->
    return 0 unless mark
    return mark.y-mark.height/2 + offset

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


  # ============= MOVE BEHAVIOR ====================== #
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
    if @dragging.get() and touch = evt.changedTouches[0]
      evt.stopPropagation()
      evt.preventDefault()
      @mark.set "x", touch.pageX - @offsetX.get()
      @mark.set "y", touch.pageY - @offsetY.get()

  touched: (evt) ->
    return unless evt 
    evt.stopPropagation()
    @dragging.set false
    @resizeDragging.set false

  mousedown: (evt) ->
    return unless evt
    evt.stopPropagation()
    @dragging.set true

  moving: (evt) ->
    return unless evt
    if @dragging.get()
      evt.stopPropagation()
      @mark.set "x", evt.pageX - @offsetX.get()
      @mark.set "y", evt.pageY - @offsetY.get()

  mouseup: (evt) ->
    return unless evt
    evt.stopPropagation()
    @dragging.set false
    @resizeDragging.set false

  # ============= RESIZE BEHAVIOR ====================== #
  resizeClick: (evt) ->
    return unless evt
    evt.stopPropagation()
    @editing.set @mark.get "id"

  resizeTouch: (evt) ->
    return unless evt
    evt.stopPropagation()
    @editing.set @mark.get "id"
    @resizeDragging.set true

  resizeTouching: (evt) ->
    return unless evt
    if @resizeDragging.get() and touch = evt.changedTouches[0]
      evt.stopPropagation()
      evt.preventDefault()
      width = touch.pageX - @getX(@mark.get(), @offsetX.get())
      width = 5 if width < 5
      height = touch.pageY - @getY(@mark.get(),@offsetY.get())
      height = 5 if height < 5
      @mark.set 'x', @mark.get('x') + (width - @mark.get('width'))/2
      @mark.set 'y', @mark.get('y') + (height - @mark.get('height'))/2
      @mark.set "width", width
      @mark.set "height", height

  resizeTouched: (evt) ->
    return unless evt
    evt.stopPropagation()
    @dragging.set false
    @resizeDragging.set false

  resizeMousedown: (evt) ->
    return unless evt
    evt.stopPropagation()
    @resizeDragging.set true

  resizeMoving: (evt) ->
    return unless evt
    if @resizeDragging.get()
      evt.stopPropagation()
      width = evt.pageX - @getX(@mark.get(), @offsetX.get())
      width = 5 if width < 5
      height = evt.pageY - @getY(@mark.get(),@offsetY.get())
      height = 5 if height < 5
      @mark.set 'x', @mark.get('x') + (width - @mark.get('width'))/2
      @mark.set 'y', @mark.get('y') + (height - @mark.get('height'))/2
      @mark.set "width", width
      @mark.set "height", height

  resizeMouseup: (evt) ->
    return unless evt
    evt.stopPropagation()
    @dragging.set false
    @resizeDragging.set false
