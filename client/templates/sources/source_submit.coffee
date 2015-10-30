Template.sourceSubmit.helpers
  has_sources: -> Sources.find().count() > 0

Template.sourceSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    source =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      type: $(e.target).find('[name=source_type]').val()
      url: $(e.target).find('[name=url]').val()
      projectId: template.data._id

    Meteor.call 'sourceInsert', source, (error, sourceId) ->
      if error
        throwError error.reason
      else
        stop_submitting()

  'click .cancel': (e) -> stop_submitting()
