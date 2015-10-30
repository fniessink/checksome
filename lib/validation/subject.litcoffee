A `subject` is valid if it has a type and is a valid item.

    @validateSubject = (subject) ->

First, check that the item has the right structure and is a valid item.

      check subject, Match.ObjectIncluding
        type: String
      validateItem subject

Then, check that a type is present. A missing type is always a fatal error.
The UI should force the user to always pick a type.

      if subject.type == ''
        throw new Meteor.Error('invalid-subject', 'You must add a type to a subject')
