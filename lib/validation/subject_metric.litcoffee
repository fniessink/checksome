A `subject_metric` is valid if it has a subject, a metric,
and is a valid item.

    @validateSubjectMetric = (subjectMetric) ->

First, check that the subject metric has the right structure and is a valid
item.

      check subjectMetric, Match.ObjectIncluding
        subject: String
        metric: String
      errors = validateItem subjectMetric

Next, check that a subject and metric are present. Subject metrics are created
server side, so when either one is missing it's a fatal error.

      if subjectMetric.subject == ''
        throw new Meteor.Error('invalid-subject-metric', 'You must add a subject to a subject-metric')
      if subjectMetric.metric == ''
        throw new Meteor.Error('invalid-subject-smetric', 'You must add a metric to a subject-metric')
      return errors
