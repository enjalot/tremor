
module.exports = class Mark
  init: ->
    @offsetX = @model.at 'offsetX'
    @offsetX.setNull 0
    @offsetY = @model.at 'offsetY'
    @offsetY.setNull 0
    @mark = @model.at 'mark'
    @editing = @model.at 'editing'
    @editing.setNull false

  create: ->

  click: (evt) ->
    @editing.set !@editing.get()

    evt.stopPropagation()

  getX: (mark, offset) ->
    return 0 unless mark
    return mark.x-mark.w/2 + offset

  getY: (mark, offset) ->
    return 0 unless mark
    return mark.y-mark.h/2 + offset

  delete: (mark, evt) ->
    return unless mark
    @model.root.del "marks.#{mark.id}"
    evt.stopPropagation()

  close: (evt) ->
    @editing.set false

  editorClick: (evt) ->
    evt.stopPropagation()
