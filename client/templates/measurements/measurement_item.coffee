Template.measurement_item.helpers
  bg_class: -> if this.target_met then 'bg-success' else 'bg-danger'
  description: ->
    if this.error_message
      return this.error_message
    return this.value + ' ' + this.unit
