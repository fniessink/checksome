    Template.subjectItem.events
      'click .edit': (e) -> start_editing(this)

    Template.subjectItem.helpers
      chartId: -> "chart" + @_id
      subjectPieChart: ->
        title:
          text: null
        credits:
          enabled: false
        chart:
          animation: false
        series: [
            type: 'pie'
            name: 'Metrics'
            data: data(@_id)
          ]
        plotOptions:
          pie:
            dataLabels:
              enabled: false
            animation: false

      data: data = (subject) ->
        subject_metrics = SubjectMetrics.find {subject: subject}
        red = 0
        green = 0
        blue = 0
        white = 0
        for subject_metric in subject_metrics.fetch()
          last_measurement = Measurements.findOne {subject_metric_id: subject_metric._id}, {sort: {updated: -1}}
          if last_measurement
            if last_measurement.error_message
              blue += 1
            else
              if last_measurement.target_met
                green += 1
              else
                red += 1
          else
            white += 1
        [
          {name: 'Target not met', y: red, color: 'red'},
          {name: 'Target met', y: green, color: 'green'},
          {name: 'No data', y: white, color: 'white'},
          {name: 'Failing', y: blue, color: 'blue'}
        ]
