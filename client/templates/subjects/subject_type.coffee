Template.subjectType.helpers
  subject_types: -> subject_types()
  type_is_selected: ->
    subject = Template.parentData()
    this._id == subject.type
