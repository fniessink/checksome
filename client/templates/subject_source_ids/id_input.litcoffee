
    Template.idInput.helpers
      id_label: ->
        current_data_type = Session.get 'currentDataType'
        data_type_labels()[current_data_type]
