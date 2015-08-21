Template.subjectSourceIdsList.helpers
  subject_source_ids: -> SubjectSourceIds.find {}, {sort: {position: 1}}
  has_sources_and_subjects: -> Sources.find().count() > 0 and Subjects.find().count() > 0
  submitting: -> Session.get('kindSubmitting') == 'subject_source_id' or SubjectSourceIds.find().count() == 0

Template.subjectSourceIdsList.onRendered ->
  options = _.extend drag_and_drop_options,
    update: (event, ui) ->
      index = 0
      _.each $(".item"), (item) ->
        SubjectSourceIds.update {_id: item.id}, {$set: {position: index++}}
  this.$(".sortable").sortable(options).disableSelection()
