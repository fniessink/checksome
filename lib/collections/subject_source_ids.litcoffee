`SubjectSourceIds` are identifications of subjects in sources. For example,
the Subversion url of a software component in Subversion, the Sonar key of
a software component in Sonar, or the project key of a project in Jira.

    @SubjectSourceIds = new Mongo.Collection 'subject_source_ids'

Updates and removals of the ids are allowed when the user is a member of the project.

    SubjectSourceIds.allow
      update: (userId, subject_source_id) -> ownsProjectItem userId, subject_source_id
      remove: (userId, subject_source_id) -> ownsProjectItem userId, subject_source_id

    Meteor.methods
      subjectSourceIdInsert: (idAttributes) ->
        check this.userId, String
        validateSubjectSourceId idAttributes
        user = Meteor.user()
        subject_source_id = _.extend idAttributes,
          userId: user._id
          submitted: new Date()
          position: 0
          kind: 'subject_source_id'

Update the positions of the existing subject source ids

        SubjectSourceIds.update({_id: s._id}, {$set: {position: s.position+1}}) for s in SubjectSourceIds.find({projectId: subject_source_id.projectId}).fetch()

Create the subject source id, save the id

        subject_source_id._id = SubjectSourceIds.insert subject_source_id
        return subject_source_id._id
