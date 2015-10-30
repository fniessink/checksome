A `subject_source_id` is valid if it has a subject, a source, and an id.

    @validateSubjectSourceId = (id) ->

First, check that the id has the right structure and is a valid item.

      check id, Match.ObjectIncluding
        id: String
        source: String
        subject: String

Next, check that an id, source, and subject are present. The UI forces the user to
select a source and subject, so if they are missing it is a fatal error.

      if id.id == ''
        throw new Meteor.Error('invalid-subject-source-id', 'You must add an id to a subject-source-id')
      if id.source == ''
        throw new Meteor.Error('invalid-subject-source-id', 'You must add a source to a subject-source-id')
      if id.subject == ''
        throw new Meteor.Error('invalid-subject-source-id', 'You must add a subject to a subject-source-id')
