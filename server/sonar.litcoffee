This job collects data from Sonar for the Sonar keys in the `SubjectSourceIds`
collection.

    class @SonarJob extends Job
      @setupCron: (parser) ->
        parser.recur().every(1).minute()

      handleJob: ->
        for subject_source_id in SubjectSourceIds.find().fetch()
          source = Sources.findOne({_id: subject_source_id.source})
          if source.type != 'sonar'
            continue
          @measure_ncloc subject_source_id, source
          @measure_duplication subject_source_id, source

      measure_ncloc: (subject_source_id, source) ->
        metric = Metrics.findOne {title: "NCLOC"}
        subject = Subjects.findOne {_id: subject_source_id.subject}
        subject_metric = SubjectMetrics.findOne {subject: subject._id, metric: metric._id}
        target = subject_metric.target or metric.target
        sonar_key = subject_source_id.id
        result = @get_json source.url, sonar_key
        if result.json
          for sonar_metric in result.json[0]['msr']
            if sonar_metric['key'] == 'ncloc'
              value = sonar_metric['val']
              target_met = ncloc_meets_target(value, target)
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
          error_message: result.error_message

      measure_duplication: (subject_source_id, source) ->
        metric = Metrics.findOne {title: "Duplication"}
        subject = Subjects.findOne {_id: subject_source_id.subject}
        subject_metric = SubjectMetrics.findOne {subject: subject._id, metric: metric._id}
        target = subject_metric.target or metric.target
        sonar_key = subject_source_id.id
        result = @get_json source.url, sonar_key
        if result.json
          for sonar_metric in result.json[0]['msr']
            if sonar_metric['key'] == 'duplicated_lines_density'
              value = sonar_metric['val']
              target_met = duplication_meets_target(value, target)
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
          error_message: result.error_message 

      get_json: (sonar_url, sonar_key) ->
        try
          result = HTTP.get sonar_url + 'api/resources?resource=' + sonar_key + '&metrics=true'
          return {json: result.data, error_message: ''}
        catch e
          return {json: null, error_message: e.message}

    Job.push new SonarJob
