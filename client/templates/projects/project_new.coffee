Template.projectNew.onCreated ->
  Session.set 'projectNewErrors', {}


Template.projectNew.onRendered ->
  $(".member-select").select2
    placeholder: TAPi18n.__ "Select project members"


Template.projectNew.helpers
  usernames: -> Meteor.users.find {}, {sort: {username: 1}}
  userIsCurrentUser: -> this._id == Meteor.userId()
  errorMessage: (field) -> Session.get('projectNewErrors')[field]
  errorClass: (field) ->
    if Session.get('projectNewErrors')[field] then 'has-error' else ''


Template.projectNew.events
  'submit form': (e) ->
    e.preventDefault()

    project =
      title: $(e.target).find('[name=title]').val()
      description: $(e.target).find('[name=description]').val()
      members: $(e.target).find('[name=members]').val() or []

    Session.set 'projectNewErrors', {}
    errors = validateProject project
    if errors.members
      Session.set 'projectNewErrors', errors
      return false

    Meteor.call 'projectInsert', project, (error, result) ->
      if error
        throwError error.reason
      else
        stop_submitting()
        Router.go 'projectPage', {_id: result._id}

  'click .cancel': (e) -> stop_submitting()
