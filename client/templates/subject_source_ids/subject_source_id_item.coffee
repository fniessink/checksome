Template.subjectSourceIdItem.events
  'click .edit': (e) -> start_editing(this)

Template.subjectSourceIdItem.helpers
  subject: -> Subjects.findOne({_id: this.subject}).title
  source: -> Sources.findOne({_id: this.source}).title
