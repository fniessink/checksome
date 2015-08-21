Template.sourceEdit.helpers
  hasNoSubjects: ->
    Subjects.find({sources: this._id}).count() == 0
  types: -> source_types()
  typeIsSelected: ->
    source = Template.parentData()
    this._id == source.type

Template.sourceEdit.events
  'submit form': (e, template) ->
    e.preventDefault()

    $title = $(e.target).find '[name=title]'
    $description = $(e.target).find '[name=description]'
    $type = $(e.target).find '[name=type]'
    $url = $(e.target).find '[name=url]'
    sourceProperties =
      title: $title.val()
      description: $description.val()
      type: $type.val()
      url: $url.val()

    Session.set 'source_title', {}
    errors = validateSource sourceProperties
    if errors.title
      Session.set 'source_title', errors
    if errors.url
      Session.set 'source_url', errors
    if errors.title or errors.url
      return false

    Sources.update this._id, {$set: sourceProperties}, (error) ->
      if error
        throwError error.reason
      else
        stop_editing()

  'click .cancel': (e) -> stop_editing()


Template.deleteSource.helpers
  translated_kind: -> TAPi18n.__ this.kind


Template.deleteSource.events
  'click .delete': (e) ->
    delete_source = =>
      Sources.remove this._id
      stop_editing()
    # Make sure the backdrop is hidden before we do anything.
    $('#deleteSource').modal('hide').on('hidden.bs.modal', delete_source)
