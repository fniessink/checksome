Template.measurement_item.helpers
  bg_class: ->
    return 'bg-info' if this.error_message
    if this.target_met then 'bg-success' else 'bg-danger'

  description: ->
    return this.error_message if this.error_message
    return this.value + this.unit + '. Target is ' + this.target + this.unit
