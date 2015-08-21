A `subject_source_id` is valid if it has a subject, a source, an id,
and is a valid item.

    @validateSubjectSourceId = (id) ->

First, check that the id has the right structure and is a valid item.

      check id, Match.ObjectIncluding
        source: String
        subject: String
      errors = validateItem id

Next, check that a source and subject are present. The UI forces the user to
select a source and subject, so if they are missing it is a fatal error.

      if id.source == ''
        throw new Meteor.Error('invalid-subject-source-id', 'You must add a source to a subject-source-id')
      if id.subject == ''
        throw new Meteor.Error('invalid-subject-source-id', 'You must add a subject to a subject-source-id')
      return errors
