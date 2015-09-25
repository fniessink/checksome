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
          subject = Subjects.findOne({_id: subject_source_id.subject})
          title = "NCLOC " + subject.title
          sonar_key = subject_source_id.title
          try
            result = HTTP.get source.url + 'api/resources?resource=' + sonar_key + '&metrics=true'
            error_message = ''
          catch e
            error_message = e.message
          if result
            json = result.data
            for metric in json[0]['msr']
              if metric['key'] == 'ncloc'
                ncloc = metric['val']
          else
            ncloc = -1
          if error_message != ''
            description = error_message
          else
            description = ncloc + ' LOC'
          insertMeasurement
            projectId: source.projectId
            title: title
            description: description
          console.log(title, description, sonar_key, source.type, source.url, ncloc)

    Job.push new SonarJob
