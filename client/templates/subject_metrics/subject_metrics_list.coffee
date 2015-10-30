Template.subjectMetricsList.helpers
  subject_metrics: -> SubjectMetrics.find {}, {sort: {position: 1}}

Template.subjectMetricsList.onRendered ->
  options = _.extend drag_and_drop_options,
    update: (event, ui) ->
      index = 0
      _.each $(".item"), (item) ->
        SubjectMetrics.update {_id: item.id}, {$set: {position: index++}}
  this.$(".sortable").sortable(options).disableSelection()
