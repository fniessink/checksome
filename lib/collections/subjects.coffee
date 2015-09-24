@Subjects = new Mongo.Collection 'subjects'

Subjects.allow
  update: (userId, subject) -> ownsProjectItem userId, subject
  remove: (userId, subject) -> ownsProjectItem userId, subject

Subjects.deny
  remove: (userId, subject) -> SubjectSourceIds.find({subject: subject._id}).count() > 0

Meteor.methods
  subjectInsert: (subjectAttributes) ->
    check this.userId, String
    validateSubject subjectAttributes
    user = Meteor.user()
    subject = _.extend subjectAttributes,
      userId: user._id
      submitted: new Date()
      position: 0
      kind: 'subject'
    # Update the positions of the existing subjects
    Subjects.update({_id: f._id}, {$set: {position: f.position+1}}) for f in Subjects.find({projectId: subject.projectId}).fetch()
    # Create the subject, save the id
    subject._id = Subjects.insert subject
    # Now create a notification, informing the project members a subject has been added
    project = Projects.findOne subject.projectId
    text = user.username + ' added subject ' + subject.title + ' to ' + project.title
    createNotification(member, user._id, subject.projectId, text) for member in project.members
    return subject._id
