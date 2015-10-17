Template.sourceType.helpers
  source_types: -> source_types()
  type_is_selected: ->
    source = Template.parentData()
    this._id == source.type
