A `measurement` is valid if it ...

    @validateMeasurement = (measurement) ->

First, check that the id has the right structure and is a valid item.

      check measurement, Match.ObjectIncluding
        projectId: String
        subject_metric_id: String
        metric_title: String
        subject_title: String
