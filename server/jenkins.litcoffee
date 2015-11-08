This job collects data from Jenkins for the job names in the
`SubjectSourceIds` collection.

    class @JenkinsJob extends Job
      @setupCron: (parser) ->
        parser.recur().every(1).minute()

      handleJob: ->
        for subject_source_id in SubjectSourceIds.find().fetch()
          source = Sources.findOne({_id: subject_source_id.source})
          if source.type != 'jenkins'
            continue
          @measure_test_results subject_source_id, source

      measure_test_results: (subject_source_id, source) ->
        metric = Metrics.findOne {title: "Test result"}
        subject = Subjects.findOne {_id: subject_source_id.subject}
        subject_metric = SubjectMetrics.findOne {subject: subject._id, metric: metric._id}
        target = subject_metric.target or metric.target
        jenkins_job = subject_source_id.id
        result = @get_json source.url, jenkins_job
        if result.json
          for action in result.json['actions']
            if 'failCount' of action
              fail_count = action.failCount
              skip_count = action.skipCount
              total_count = action.totalCount
          value = fail_count + skip_count
          target_met = test_result_meets_target(value, target)
          error_message = null
        else
          value = null
          target_met = null
          error_message = result.error_message
        insertOrUpdateMeasurement
          projectId: source.projectId
          subject_metric_id: subject_metric._id
          metric_title: metric.title
          subject_title: subject.title
          value: value
          unit: metric.unit
          target: target
          target_met: target_met
          error_message: error_message

      get_json: (jenkins_url, jenkins_job) ->
        try
          result = HTTP.get jenkins_url + 'job/' + jenkins_job + '/lastBuild/api/json?tree=actions[failCount,skipCount,totalCount]'
          return {json: result.data, error_message: ''}
        catch e
          return {json: null, error_message: e.message}

    Job.push new JenkinsJob
