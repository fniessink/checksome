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
  source1 =
    title: "Sonar"
    description: "Sonar is a tool for measuring the quality of source code."
    type: 'sonar'
    url: 'http://sonar/'
    projectId: projectId
    userId: user._id
    position: 0
    submitted: new Date
    kind: 'source'
  source1Id = Sources.insert source1
  source2 =
    title: "Jenkins"
    description: "Jenkins is a tool for continuous integration."
    type: 'jenkins'
    url: 'http://jenkins/'
    projectId: projectId
    userId: user._id
    position: 1
    submitted: new Date
    kind: 'source'
  source2Id = Sources.insert source2
  source3 =
    title: "Jira"
    description: "Jira is an issue tracker."
    type: 'jira'
    url: 'http://jira/'
    projectId: projectId
    userId: user._id
    position: 2
    submitted: new Date
    kind: 'source'
  source3Id = Sources.insert source3
  return user
