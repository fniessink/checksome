@Subjects = new Mongo.Collection 'subjects'

@subject_types = ->
  [{_id: 'component', title: 'Component'},
   {_id: 'application', title: 'Application'},
   {_id: 'team', title: 'Team'}]

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
    # Add the subject Metrics
    insertSubjectMetricsForSubject subject
    return subject._id

  subjectEdit: (subject, subjectAttributes) ->
    validateSubject subject
    validateSubject subjectAttributes
    type_changed = subject.type != subjectAttributes.type
    if type_changed
      deleteSubjectMetricsForSubject subject
    Subjects.update subject._id, {$set: subjectAttributes}
    if type_changed
      insertSubjectMetricsForSubject Subjects.findOne subject._id

  subjectRemove: (subject) ->
    validateSubject subject
    deleteSubjectMetricsForSubject subject
    Subjects.remove subject
