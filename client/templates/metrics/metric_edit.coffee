Template.metricEdit.onCreated ->
  Session.set Template.currentData().control_id, {}

errorMessage = (field) ->
  Session.get(Template.currentData().control_id)[field]

Template.metricEdit.helpers
  errorMessage: errorMessage

  errorClass: (field) ->
    if errorMessage(field) then 'has-error' else ''


Template.metricEdit.events
  'submit form': (e, template) ->
    e.preventDefault()

    metricProperties =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      target: parseInt($(e.target).find('[name=target]').val(), 10)

    Session.set 'metric_title', {}
    errors = validateMetric metricProperties
    if errors.title
      Session.set 'metric_title', errors
    if errors.target
      Session.set 'metric_target', errors
    if errors.title or errors.target
      return false

    Metrics.update this._id, {$set: metricProperties}, (error) ->
      if error
        throwError error.reason
      else
        stop_editing()

  'click .cancel': (e) -> stop_editing()
