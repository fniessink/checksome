Template.measurementsList.helpers
  measurements: -> Measurements.find {}, {sort: {position: 1}}

Template.measurementsList.onRendered ->
  options = _.extend drag_and_drop_options,
    update: (event, ui) ->
      index = 0
      _.each $(".item"), (item) ->
        Measurements.update {_id: item.id}, {$set: {position: index++}}
  this.$(".sortable").sortable(options).disableSelection()
