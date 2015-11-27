When the template is created, initialize a session variable to keep track of
the current source.

    Template.sourceSelect.onCreated ->
      Session.set('currentSourceType', null)

When the user selects a different source, update the session variable.

    Template.sourceSelect.events
      'change .source': (e) ->
        source_id = $(e.target).val()
        current_source_type = Sources.findOne({_id: source_id}).type
        Session.set('currentSourceType', current_source_type)

    Template.sourceSelect.helpers
      sources: -> Sources.find()
      sourceIsSelected: ->
        subject_source_id = Template.parentData()
        @_id == subject_source_id.source
