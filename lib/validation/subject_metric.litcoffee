A `subject_metric` is valid if it has a valid target.

    @validateSubjectMetric = (subjectMetric) ->

First, check that the subject metric has the right structure and is a valid
item.

      check subjectMetric, Match.ObjectIncluding
        target: Match.Optional(Number)

Next, check that the target is zero or greater.

      errors = {}
      if subjectMetric.target < 0
        errors.target = TAPi18n.__ "Please provide a positive target value"
      return errors
