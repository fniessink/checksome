Template.subjectMetricItem.events
  'click .edit': (e) -> start_editing(this)

Template.subjectMetricItem.helpers
  title: ->
    subject_title = Subjects.findOne({_id: this.subject}).title
    metric_title = Metrics.findOne({_id: this.metric}).title
    return subject_title + ' ' + metric_title

  bg_class: ->
    last_measurement = Measurements.findOne {subject_metric_id: this._id}, {sort: {updated: -1}}
    return 'bg-info' if last_measurement.error_message
    if last_measurement.target_met then 'bg-success' else 'bg-danger'

  description: ->
    last_measurement = Measurements.findOne {subject_metric_id: this._id}, {sort: {updated: -1}}
    return last_measurement.error_message if last_measurement.error_message
    return last_measurement.value + last_measurement.unit + '. Target is ' + last_measurement.target + last_measurement.unit
