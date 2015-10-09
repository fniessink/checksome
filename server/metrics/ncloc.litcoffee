NCLOC metric.

    class @NCLOC
      constructor: ->
        @metric = Metrics.findOne {title: "NCLOC"}

      title: ->
        return "NCLOC"

      meets_target: (value) ->
        console.log(value, @metric.target)
        return value < @metric.target
