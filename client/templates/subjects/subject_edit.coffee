Template.subjectEdit.helpers
  hasNoSubjectSourceIds: -> SubjectSourceIds.find({subject: this._id}).count() == 0

Template.subjectEdit.events
  'submit form': (e, template) ->
    e.preventDefault()

    subjectProperties =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      type: $(e.target).find('[name=subject_type]').val()

    Meteor.call 'subjectEdit', this, subjectProperties, (error, result) ->
      if error
        throwError error.reason
      else
        stop_editing()

  'click .cancel': (e) -> stop_editing()


Template.deleteSubject.helpers
  translated_kind: -> TAPi18n.__ this.kind


Template.deleteSubject.events
  'click .delete': (e) ->
    delete_subject = =>
      Meteor.call 'subjectRemove', this
      stop_editing()
    # Make sure the backdrop is hidden before we do anything.
    $('#deleteSubject').modal('hide').on('hidden.bs.modal', delete_subject)
