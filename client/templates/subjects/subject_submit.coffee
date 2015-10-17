Template.subjectSubmit.helpers
  has_subjects: -> Subjects.find().count() > 0


Template.subjectSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    subject =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      type: $(e.target).find('[name=subject_type]').val()
      projectId: template.data._id

    Session.set 'subject_title', {}
    errors = validateSubject subject
    if errors.title
      Session.set 'subject_title', errors
      return false

    Meteor.call 'subjectInsert', subject, (error, subjectId) ->
      if error
        throwError error.reason
      else
        stop_submitting()

  'click .cancel': (e) -> stop_submitting()
