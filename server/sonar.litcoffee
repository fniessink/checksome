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

      measure_ncloc: (subject_source_id, source) ->
        metric = new NCLOC()
        subject = Subjects.findOne {_id: subject_source_id.subject}
        subject_metric = SubjectMetrics.findOne {subject: subject._id, metric: metric.metric._id}
        sonar_key = subject_source_id.id
        result = @get_json source.url, sonar_key
        if result.json
          for sonar_metric in result.json[0]['msr']
            if sonar_metric['key'] == 'ncloc'
              ncloc = sonar_metric['val']
              target_met = metric.meets_target(ncloc)
        insertOrUpdateMeasurement
          projectId: source.projectId
          subject_metric_id: subject_metric._id
          metric_title: metric.title()
          subject_title: subject.title
          value: ncloc or null
          unit: "LOC"
          target: metric.target
          target_met: target_met or null
          error_message: result.error_message or null
        console.log(sonar_key, source.type, source.url, ncloc, result.error_message, target_met)

      get_json: (sonar_url, sonar_key) ->
        try
          result = HTTP.get sonar_url + 'api/resources?resource=' + sonar_key + '&metrics=true'
          return {json: result.data, error_message: ''}
        catch e
          return {json: null, error_message: e.message}

    Job.push new SonarJob
