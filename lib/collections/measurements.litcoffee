`Measurements` are ...

    @Measurements = new Mongo.Collection 'measurements'

    Measurements.allow
      update: (userId, measurement) -> false
      remove: (userId, measurement) -> false

Insert or update a measurement.

    @insertOrUpdateMeasurement = (measurementAttributes) ->
      validateMeasurement measurementAttributes
      selector =
        title: measurementAttributes.title
        projectId: measurementAttributes.projectId
      previous = Measurements.findOne selector, {sort: {updated: -1}}
      now = new Date()
      if previous and previous.description == measurementAttributes.description
        Measurements.update previous._id, {$set: {updated: now}}
        return previous._id
      else
        measurement = _.extend measurementAttributes,
          added: now
          updated: now
        measurement._id = Measurements.insert measurement
        return measurement._id
