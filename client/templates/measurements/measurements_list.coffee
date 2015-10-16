Template.measurementsList.helpers
  measurements: -> Measurements.find {}, {sort: {updated: -1}}
