Template.subjectSourceIdSubmit.helpers
  sources: -> Sources.find()
  subjects: -> Subjects.find()

Template.subjectSourceIdSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    id =
      id: $(e.target).find('[name=id]').val()
      subject: $(e.target).find('[name=subject]').val()
      source: $(e.target).find('[name=source]').val()
      projectId: template.data._id

    Meteor.call 'subjectSourceIdInsert', id, (error, result) ->
      if error
        throwError error.reason
      else
        stop_submitting()

  'click .cancel': (e) -> stop_submitting()
