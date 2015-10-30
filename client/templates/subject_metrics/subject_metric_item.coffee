Template.subjectMetricItem.events
  'click .edit': (e) -> start_editing(this)

Template.subjectMetricItem.helpers
  title: ->
    subject_title = Subjects.findOne({_id: this.subject}).title
    metric_title = Metrics.findOne({_id: this.metric}).title
    return subject_title + ' ' + metric_title
