module.exports = class Manuscript
  init: ->
    manuscriptId = @model.root.get "$render.params.manuscriptId"
    @model.set "manuscriptId", manuscriptId
    @filter = @model.root.filter("folios", (folio) -> folio.manuscriptId == manuscriptId)
      .sort (a,b) ->
        if(a.index == b.index)
          if a.side == "r"
            return -1
          else
            return 1

        return a.index - b.index

    @model.ref "folios", @filter

  create: ->
    window.PAGE = @