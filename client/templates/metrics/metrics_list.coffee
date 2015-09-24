Template.metricsList.helpers
  metrics: -> Metrics.find {}, {sort: {position: 1}}

Template.metricsList.onRendered ->
  options = _.extend drag_and_drop_options,
    update: (event, ui) ->
      index = 0
      _.each $(".item"), (item) ->
        Metrics.update {_id: item.id}, {$set: {position: index++}}
  this.$(".sortable").sortable(options).disableSelection()
