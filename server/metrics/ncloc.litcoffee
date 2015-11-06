NCLOC metric.

    class @NCLOC
      constructor: ->
        @metric = Metrics.findOne {title: "NCLOC"}

      title: ->
        return "NCLOC"

      meets_target: (value) ->
        return value < @metric.target
