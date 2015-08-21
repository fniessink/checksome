@validateSubject = (subject) ->
  check subject, Match.ObjectIncluding
    sources: [String]
  errors = validateItem subject
  if subject.sources.length == 0
    if Meteor.isServer
      throw new Meteor.Error('invalid-subject', 'You must add one or more sources to the subject')
    else
      errors.sources = TAPi18n.__ "Please select one or more sources for the subject"
  return errors
