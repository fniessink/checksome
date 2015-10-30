Template.sourceEdit.helpers
  hasNoSubjects: ->
    Subjects.find({sources: this._id}).count() == 0

Template.sourceEdit.events
  'submit form': (e, template) ->
    e.preventDefault()

    sourceProperties =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      type: $(e.target).find('[name=source_type]').val()
      url: $(e.target).find('[name=url]').val()

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
