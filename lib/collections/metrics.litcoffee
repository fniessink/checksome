`Metrics` are attributes that can be measured. For example, size, velocity,
and complexity.

    @Metrics = new Mongo.Collection 'metrics'

Updates of the metrics are allowed when the user is a member of the project.

    Metrics.allow
      update: (userId, metric) -> ownsProjectItem userId, metric
      remove: (userId, metric) -> false

    @metricInsert = (metricAttributes) ->
      validateMetric metricAttributes
      metric = _.extend metricAttributes,
        submitted: new Date()
        position: 0
        kind: 'metric'

Update the positions of the existing metrics

      Metrics.update({_id: m._id}, {$set: {position: m.position+1}}) for m in Metrics.find({projectId: metric.projectId}).fetch()

Create the metric

      metric._id = Metrics.insert metric
      return metric._id

    @createMetrics = (project) ->
      if not Metrics.findOne({projectId: project._id, title: "NCLOC"})
        metricInsert
          projectId: project._id
          title: "NCLOC"
          description: "Size of the software in non-commented lines of code"
          target: 10000  # NCLOC
