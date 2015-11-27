Template.subjectSourceIdEdit.helpers
  data_types: ->
    current_source_type = Session.get('currentSourceType') or Sources.findOne({_id: this.source}).type
    source_data_types()[current_source_type]

  dataTypeIsSelected: ->
    subject_source_id = Template.parentData()
    @_id == subject_source_id.data_type

Template.subjectSourceIdEdit.events
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
