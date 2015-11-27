Accounts.onCreateUser (options, user) ->
  tutorial =
    title: "Welcome to Checksome, #{user.username}!"
    description: "Checksome ..."
    members: [user._id]
    userId: user._id
    submitted: new Date
    kind: 'project'
  projectId = Projects.insert tutorial
  project = Projects.findOne({_id: projectId})
  createMetrics project
  return user
