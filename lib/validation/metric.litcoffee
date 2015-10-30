A `metric` is valid if it has a valid target.

    @validateMetric = (metric) ->

First, check that the metric has the right structure.

      check metric, Match.ObjectIncluding
        target: Match.Optional(Number)

Next, check that the target is zero or greater.

      errors = {}
      if metric.target < 0
        errors.target = TAPi18n.__ "Please provide a positive target value"
      return errors
