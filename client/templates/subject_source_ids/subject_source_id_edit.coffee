Template.subjectSourceIdEdit.onCreated ->
  Session.set('subjectSourceIdEdit:currentSourceType', null)

Template.subjectSourceIdEdit.helpers
  subjects: -> Subjects.find()
  sources: -> Sources.find()
  data_types: ->
    current_source_type = Session.get('subjectSourceIdEdit:currentSourceType') or Sources.findOne({_id: this.source}).type
    return source_data_types()[current_source_type]

  sourceIsSelected: ->
    subject_source_id = Template.parentData()
    this._id == subject_source_id.source
  subjectIsSelected: ->
    subject_source_id = Template.parentData()
    this._id == subject_source_id.subject
  dataTypeIsSelected: ->
    subject_source_id = Template.parentData()
    this._id == subject_source_id.data_type

Template.subjectSourceIdEdit.events
  'change .source': (e) ->
    source_id = $(e.target).val()
    current_source_type = Sources.findOne({_id: source_id}).type
    Session.set('subjectSourceIdEdit:currentSourceType', current_source_type)

  'submit form': (e, template) ->
    e.preventDefault()

    idProperties =
      id: $(e.target).find('[name=id]').val()
      subject: $(e.target).find('[name=subject]').val()
      source: $(e.target).find('[name=source]').val()
      data_type: $(e.target).find('[name=data_type]').val()

    SubjectSourceIds.update this._id, {$set: idProperties}, (error) ->
      if error
        throwError error.reason
      else
        stop_editing()

  'click .cancel': (e) -> stop_editing()


Template.deleteSubjectSourceId.helpers
  translated_kind: -> TAPi18n.__ this.kind


Template.deleteSubjectSourceId.events
  'click .delete': (e) ->
    delete_subject_source_id = =>
      SubjectSourceIds.remove this._id
      stop_editing()
    # Make sure the backdrop is hidden before we do anything.
    $('#deleteSubjectSourceId').modal('hide').on('hidden.bs.modal', delete_subject_source_id)
