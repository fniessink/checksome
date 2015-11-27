This job collects data from Jira.

    class @JiraJob extends Job
      @setupCron: (parser) ->
        parser.recur().every(1).minute()

      handleJob: ->
        for subject_source_id in SubjectSourceIds.find().fetch()
          source = Sources.findOne({_id: subject_source_id.source})
          if source.type != 'jira'
            continue
          @measure_open_bugs subject_source_id, source

      measure_open_bugs: (subject_source_id, source) ->
        metric = Metrics.findOne {title: "Open bugs"}
        subject = Subjects.findOne {_id: subject_source_id.subject}
        subject_metric = SubjectMetrics.findOne {subject: subject._id, metric: metric._id}
        target = subject_metric.target or metric.target
        jira_query = subject_source_id.id
        result = @get_json source.url, jira_query, source.username, source.password
        if result.json
          value = result.json['total']
          target_met = open_bugs_meets_target(value, target)
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

      get_json: (jira_url, query_id, username, password) ->
        credentials = {auth: "#{username}:#{password}"}
        try
          result = HTTP.get jira_url + 'rest/api/2/filter/' + query_id, credentials
          search_url = EJSON.parse(result.content)['searchUrl']
          result = HTTP.get search_url, credentials
          return {json: EJSON.parse(result.content), error_message: ''}
        catch e
          return {json: null, error_message: e.message}

    Job.push new JiraJob
