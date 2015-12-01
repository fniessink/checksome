
    Template.idInput.helpers
      ids: -> Session.get('currentSource').ids
      idIsSelected: ->
        subject_source_id = Template.parentData()
        if subject_source_id
          @_id == subject_source_id.id
        else
          false
      id_label: ->
        current_data_type = Session.get 'currentDataType'
        data_type_labels()[current_data_type]
