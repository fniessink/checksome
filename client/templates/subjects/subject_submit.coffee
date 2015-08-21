Template.subjectSubmit.onCreated ->
  Session.set 'subjectSubmitErrors', {}


Template.subjectSubmit.onRendered ->
  this.$(".source-select").select2
    placeholder: TAPi18n.__ "Select sources"


Template.subjectSubmit.helpers
  errorMessage: (field) -> Session.get('subjectSubmitErrors')[field]
  errorClass: (field) ->
    if Session.get('subjectSubmitErrors')[field] then 'has-error' else ''
  sources: -> Sources.find()
  has_subjects: -> Subjects.find().count() > 0


Template.subjectSubmit.events
  'submit form': (e, template) ->
    e.preventDefault()

    $title = $(e.target).find '[name=title]'
    $description = $(e.target).find '[name=description]'
    $sources = $(e.target).find '[name=sources]'
    subject =
      title: $title.val()
      description: $description.val()
      sources: $sources.val() or []
      projectId: template.data._id

    Session.set 'subjectSubmitErrors', {}
    Session.set 'subject_title', {}
    errors = validateSubject subject
    if errors.title
      Session.set 'subject_title', errors
    if errors.sources
      Session.set 'subjectSubmitErrors', errors
    if errors.title or errors.sources
      return false

    Meteor.call 'subjectInsert', subject, (error, subjectId) ->
      if error
        throwError error.reason
      else
        $title.val('')
        $description.val('')

  'click .cancel': (e) -> stop_submitting()
