When the template is created, initialize a session variable to keep track of
the current source.

    Template.sourceSelect.onCreated ->
      Session.set 'currentSource', Sources.findOne()

When the user selects a different source, update the session variable.

    Template.sourceSelect.events
      'change .source': (e) ->
        source_id = $(e.target).val()
        current_source = Sources.findOne({_id: source_id})
        Session.set 'currentSource', current_source
        current_data_type = source_data_types()[current_source.type][0]._id
        Session.set 'currentDataType', current_data_type

    Template.sourceSelect.helpers
      sources: -> Sources.find()
      sourceIsSelected: ->
        subject_source_id = Template.parentData()
        @_id == subject_source_id.source
