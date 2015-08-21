Template.subjectEdit.onCreated ->
  Session.set 'subjectEditErrors', {}

Template.subjectEdit.onRendered ->
  this.$(".source-select").select2
    placeholder: TAPi18n.__ "Select sources"

Template.subjectEdit.helpers
  errorMessage: (field) -> Session.get('subjectEditErrors')[field]
  errorClass: (field) ->
    if Session.get('subjectEditErrors')[field] then 'has-error' else ''
  sources: -> Sources.find()
  sourceIsSelected: ->
    subject = Template.parentData()
    this._id in subject.sources
  hasNoRisks: -> Risks.find({subjects: this._id}).count() == 0

Template.subjectEdit.events
  'submit form': (e, template) ->
    e.preventDefault()

    $title = $(e.target).find '[name=title]'
    $description = $(e.target).find '[name=description]'
    $sources = $(e.target).find '[name=sources]'
    subjectProperties =
      title: $title.val()
      description: $description.val()
      sources: $sources.val() or []

    Session.set 'subject_title', {}
    Session.set 'subjectEditErrors', {}
    errors = validateSubject subjectProperties
    if errors.title
      Session.set 'subject_title', errors
    if errors.sources
      Session.set 'subjectEditErrors', errors
    if errors.title or errors.sources
      return false

    Subjects.update this._id, {$set: subjectProperties}, (error) ->
      if error
        throwError error.reason
      else
        stop_editing()

  'click .cancel': (e) -> stop_editing()


Template.deleteSubject.helpers
  translated_kind: -> TAPi18n.__ this.kind


Template.deleteSubject.events
  'click .delete': (e) ->
    delete_subject = =>
      Subjects.remove this._id
      stop_editing()
    # Make sure the backdrop is hidden before we do anything.
    $('#deleteSubject').modal('hide').on('hidden.bs.modal', delete_subject)
