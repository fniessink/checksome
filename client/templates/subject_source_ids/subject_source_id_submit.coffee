Template.subjectSourceIdSubmit.onCreated ->
  Session.set('subjectSourceIdSubmit:currentSourceType', null)

Template.subjectSourceIdSubmit.helpers
  sources: -> Sources.find()
  subjects: -> Subjects.find()
  data_types: ->
    current_source_type = Session.get('subjectSourceIdSubmit:currentSourceType') or Sources.find().fetch()[0].type
    return source_data_types()[current_source_type]

Template.subjectSourceIdSubmit.events
  'change .source': (e) ->
    source_id = $(e.target).val()
    current_source_type = Sources.findOne({_id: source_id}).type
    Session.set('subjectSourceIdSubmit:currentSourceType', current_source_type)

  'submit form': (e, template) ->
    e.preventDefault()

    id =
      id: $(e.target).find('[name=id]').val()
      subject: $(e.target).find('[name=subject]').val()
      source: $(e.target).find('[name=source]').val()
      data_type: $(e.target).find('[name=data_type]').val()
      projectId: template.data._id

    Meteor.call 'subjectSourceIdInsert', id, (error, result) ->
      if error
        throwError error.reason
      else
        stop_submitting()

  'click .cancel': (e) -> stop_submitting()
