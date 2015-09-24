`Metrics` are ...

    @Measurements = new Mongo.Collection 'measurements'

    Measurements.allow
      update: (userId, measurement) -> false
      remove: (userId, measurement) -> false

Insert a new measurement

    @insertMeasurement = (measurementAttributes) ->
      validateMeasurement measurementAttributes
      measurement = _.extend measurementAttributes,
        submitted: new Date()
        position: 0
        kind: 'measurement'

Update the positions of the existing measurements

      Measurements.update({_id: m._id}, {$set: {position: m.position+1}}) for m in Measurements.find({projectId: measurement.projectId}).fetch()

Create the measurement

      measurement._id = Measurements.insert measurement
      return measurement._id
