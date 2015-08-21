Template.subjectSourceIdSubmit.helpers
  sources: -> Sources.find()
  subjects: -> Subjects.find()


Template.subjectSourceIdSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    id =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      subject:  $(e.target).find('[name=subject]').val()
      source: $(e.target).find('[name=source]').val()
      projectId: template.data._id

    Session.set 'subject_source_id_title', {}
    errors = validateSubjectSourceId id
    if errors.title
      Session.set 'subject_source_id_title', errors
      return false

    Meteor.call 'subjectSourceIdInsert', id, (error, idId) ->
      if error
        throwError error.reason
      else
        stop_submitting()

  'click .cancel': (e) -> stop_submitting()
