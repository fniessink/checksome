Template.sourceSubmit.helpers
  has_sources: -> Sources.find().count() > 0
  types: -> source_types()

Template.sourceSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    source =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      type: $(e.target).find('[name=type]').val()
      url: $(e.target).find('[name=url]').val()
      projectId: template.data._id

    Session.set 'source_title', {}
    errors = validateSource source
    if errors.title
      Session.set 'source_title', errors
    if errors.url
      Session.set 'source_url', errors
    if errors.title or errors.url
      return false

    Meteor.call 'sourceInsert', source, (error, sourceId) ->
      if error
        throwError error.reason
      else
        stop_submitting()

  'click .cancel': (e) -> stop_submitting()
