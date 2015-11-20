Template.subjectSourceIdItem.events
  'click .edit': (e) -> start_editing(this)

Template.subjectSourceIdItem.helpers
  subject: -> Subjects.findOne({_id: this.subject}).title
  source: -> Sources.findOne({_id: this.source}).title
  data_type: ->
    source_type = Sources.findOne({_id: this.source}).type
    data_types = source_data_types()[source_type]
    for data_type in data_types
      if data_type._id == this.data_type
        return data_type.title
