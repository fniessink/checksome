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
        title = metric.title() + " " + subject.title
        sonar_key = subject_source_id.title
        result = @get_json source.url, sonar_key
        if result.json
          for sonar_metric in result.json[0]['msr']
            if sonar_metric['key'] == 'ncloc'
              ncloc = sonar_metric['val']
        else
          ncloc = -1
        if result.error_message
          description = result.error_message
        else
          target_met = metric.meets_target(ncloc)
          description = ncloc + ' LOC'
        insertMeasurement
          projectId: source.projectId
          title: title
          description: description
          value: ncloc
          target: metric.target
          target_met: target_met
        console.log(title, description, sonar_key, source.type, source.url, ncloc)

      get_json: (sonar_url, sonar_key) ->
        try
          result = HTTP.get sonar_url + 'api/resources?resource=' + sonar_key + '&metrics=true'
          return {json: result.data, error_message: ''}
        catch e
          return {json: null, error_message: e.message}

    Job.push new SonarJob
