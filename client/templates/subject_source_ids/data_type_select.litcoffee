    Template.dataTypeSelect.helpers

The data type is updated whenever the user selects another source type.

      data_types: ->
        current_source_type = Session.get('currentSourceType')
        if not current_source_type
          current_source_type = if @source then Sources.findOne({_id: @source}).type else 'sonar'
        source_data_types()[current_source_type]

      dataTypeIsSelected: ->
        subject_source_id = Template.parentData()
        if subject_source_id
          @_id == subject_source_id.data_type
        else
          false
