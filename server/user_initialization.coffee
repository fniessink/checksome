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
    description: "This is an example of a source. In this case Sonar, a tool
      used for measuring the quality of source code."
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
    description: "An example source, in this case Jenkins, a CI-server."
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
  subject1 =
    title: "Subject 1"
    description: "This is an example of a subject. Subjects are technical
      components, teams, and other things that can be measured."
    projectId: projectId
    userId: user._id
    position: 0
    submitted: new Date
    kind: 'subject'
  subject1Id = Subjects.insert subject1
  subject2 =
    title: "Subject 2"
    description: "This is another example of a subject."
    projectId: projectId
    userId: user._id
    position: 1
    submitted: new Date
    kind: 'subject'
  subject2Id = Subjects.insert subject2
  return user
