Template.subjectsList.helpers
  subjects: -> Subjects.find {}, {sort: {position: 1}}
  submitting: -> Session.get('kindSubmitting') == 'subject' or Subjects.find().count() == 0

Template.subjectsList.onRendered ->
  options = _.extend drag_and_drop_options,
    update: (event, ui) ->
      index = 0
      _.each $(".item"), (item) ->
        Subjects.update {_id: item.id}, {$set: {position: index++}}
  this.$(".sortable").sortable(options).disableSelection()
