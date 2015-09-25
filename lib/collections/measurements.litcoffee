`Measurements` are ...

    @Measurements = new Mongo.Collection 'measurements'

    Measurements.allow
      update: (userId, measurement) -> false
      remove: (userId, measurement) -> false

Insert a new measurement

    @insertMeasurement = (measurementAttributes) ->
      validateMeasurement measurementAttributes
      measurement = _.extend measurementAttributes,
        submitted: new Date()
        kind: 'measurement'

Create the measurement

      measurement._id = Measurements.insert measurement
      return measurement._id
