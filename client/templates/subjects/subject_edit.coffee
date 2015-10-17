Template.subjectEdit.helpers
  hasNoSubjectSourceIds: -> SubjectSourceIds.find({subject: this._id}).count() == 0

Template.subjectEdit.events
  'submit form': (e, template) ->
    e.preventDefault()

    subjectProperties =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      type: $(e.target).find('[name=subject_type]').val()

    Session.set 'subject_title', {}
    errors = validateSubject subjectProperties
    if errors.title
      Session.set 'subject_title', errors
      return false

    Subjects.update this._id, {$set: subjectProperties}, (error) ->
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
      Subjects.remove this._id
      stop_editing()
    # Make sure the backdrop is hidden before we do anything.
    $('#deleteSubject').modal('hide').on('hidden.bs.modal', delete_subject)
