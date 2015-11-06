`Measurements` are the value of specific metrics for specific subjects over
a specific period of time.

    @Measurements = new Mongo.Collection 'measurements'

    Measurements.allow
      update: (userId, measurement) -> false
      remove: (userId, measurement) -> false

Insert or update a measurement.

    @insertOrUpdateMeasurement = (next) ->
      validateMeasurement next
      previous = Measurements.findOne {subject_metric_id: next.subject_metric_id}, {sort: {updated: -1}}
      now = new Date()
      if previous and (previous.error_message == next.error_message) and
                      (previous.value == next.value) and
                      (previous.target == next.target)
        Measurements.update previous._id, {$set: {updated: now}}
        console.log('Updated', previous.subject_title, previous.metric_title)
        return previous._id
      else
        measurement = _.extend next,
          added: now
          updated: now
        measurement._id = Measurements.insert measurement
        console.log('Added', measurement.subject_title, measurement.metric_title, measurement.value,
                    measurement.target, measurement.error_message)
        return measurement._id
