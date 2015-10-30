Template.subjectMetricEdit.onCreated ->
  Session.set Template.currentData().control_id, {}

errorMessage = (field) ->
  Session.get(Template.currentData().control_id)[field]

Template.subjectMetricEdit.helpers
  errorMessage: errorMessage

  errorClass: (field) ->
    if errorMessage(field) then 'has-error' else ''


Template.subjectMetricEdit.events
  'submit form': (e, template) ->
    e.preventDefault()

    subjectMetricProperties =
      description: $(e.target).find('[name=description]').val()
      target: parseInt($(e.target).find('[name=target]').val(), 10)

    Session.set 'subject_metric_title', {}
    errors = validateSubjectMetric subjectMetricProperties
    if errors.target
      Session.set 'subject_metric_target', errors
    if errors.target
      return false

    SubjectMetrics.update this._id, {$set: subjectMetricProperties}, (error) ->
      if error
        throwError error.reason
      else
        stop_editing()

  'click .cancel': (e) -> stop_editing()
