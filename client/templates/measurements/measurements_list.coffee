Template.measurementsList.helpers
  measurements: -> Measurements.find {}, {sort: {submitted: -1}}
