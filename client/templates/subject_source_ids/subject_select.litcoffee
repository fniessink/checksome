    Template.subjectSelect.helpers
      subjects: -> Subjects.find()
      subjectIsSelected: ->
        subject_source_id = Template.parentData()
        @_id == subject_source_id.subject
