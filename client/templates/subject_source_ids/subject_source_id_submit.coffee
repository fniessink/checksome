Template.subjectSourceIdSubmit.helpers
  sources: -> Sources.find()
  subjects: -> Subjects.find()


Template.subjectSourceIdSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    $title = $(e.target).find '[name=title]'
    $description = $(e.target).find '[name=description]'
    $subject = $(e.target).find '[name=subject]'
    $source = $(e.target).find '[name=source]'
    id =
      title: $title.val()
      description: $description.val()
      subject: $subject.val()
      source: $source.val()
      projectId: template.data._id

    Session.set 'subject_source_id_title', {}
    errors = validateSubjectSourceId id
    if errors.title
      Session.set 'subject_title', errors
      return false

    Meteor.call 'subjectSourceIdInsert', id, (error, idId) ->
      if error
        throwError error.reason
      else
        $title.val('')
        $description.val('')

  'click .cancel': (e) -> stop_submitting()
