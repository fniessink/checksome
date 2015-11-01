`Measurements` are ...

    @Measurements = new Mongo.Collection 'measurements'

    Measurements.allow
      update: (userId, measurement) -> false
      remove: (userId, measurement) -> false

Insert or update a measurement.

    @insertOrUpdateMeasurement = (next) ->
      validateMeasurement next
      selector =
        title: next.title
        projectId: next.projectId
      previous = Measurements.findOne selector, {sort: {updated: -1}}
      now = new Date()
      if previous and previous.error_message == next.error_message and previous.value == next.value
        Measurements.update previous._id, {$set: {updated: now}}
        return previous._id
      else
        measurement = _.extend next,
          added: now
          updated: now
        measurement._id = Measurements.insert measurement
        return measurement._id
