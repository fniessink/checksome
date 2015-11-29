When the template is created, initialize a session variable to keep track of
the current data type.

    Template.dataTypeSelect.onCreated ->
      current_source_type = Session.get 'currentSourceType'
      subject_source_id = Template.currentData()
      if subject_source_id and subject_source_id.data_type
        current_data_type = subject_source_id.data_type
      else
        current_data_type = source_data_types()[current_source_type][0]._id
      Session.set 'currentDataType', current_data_type

When the user selects a different source, update the session variable.

    Template.dataTypeSelect.events
      'change .data_type': (e) ->
        current_data_type = $(e.target).val()
        Session.set 'currentDataType', current_data_type

The data type is updated whenever the user selects another source type.

    Template.dataTypeSelect.helpers
      data_types: ->
        current_source_type = Session.get 'currentSourceType'
        source_data_types()[current_source_type]

      dataTypeIsSelected: ->
        subject_source_id = Template.parentData()
        if subject_source_id
          @_id == subject_source_id.data_type
        else
          false
