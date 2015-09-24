A `measurement` is valid if it is a valid item.

    @validateMeasurement = (measurement) ->
      return validateItem measurement
