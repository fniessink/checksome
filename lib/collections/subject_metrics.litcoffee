`SubjectMetrics` are metrics applied to specific subjects. For example, the
size of a component, the velocity of a team, or the performance of an
application.

    @SubjectMetrics = new Mongo.Collection 'subject_metrics'

Updates of subject metrics are allowed when the user is a member of the project.

    SubjectMetrics.allow
      update: (userId, subjectMetric) -> ownsProjectItem userId, subjectMetric
      remove: (userId, subjectMetric) -> ownsProjectItem userId, subjectMetric

    @subjectMetricInsert = (subjectMetricAttributes) ->
      validateSubjectMetric subjectMetricAttributes
      subjectMetric = _.extend subjectMetricAttributes,
        submitted: new Date()
        position: 0
        kind: 'subject_metric'

Update the positions of the existing subject metrics

      SubjectMetrics.update({_id: s._id}, {$set: {position: s.position+1}}) for s in SubjectMetrics.find({projectId: subjectMetric.projectId}).fetch()

Create the subject metric

      subjectMetric._id = SubjectMetrics.insert subjectMetric
      return subjectMetric._id

Create/remove subject-metrics when a subject is added/removed:

    @insertSubjectMetricsForSubject = (subject) ->
      metrics = Metrics.find({subject_types: subject.type}).fetch()
      projectId = subject.projectId
      subjectMetricInsert({title: subject.title + ' ' + metric.title, subject: subject._id, metric: metric._id, projectId: projectId}) for metric in metrics

    @deleteSubjectMetricsForSubject = (subject) ->
      SubjectMetrics.remove {subject: subject._id}
