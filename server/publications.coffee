Meteor.publish 'projects', ->
  Projects.find {members: this.userId}

Meteor.publish 'subjects', (projectId) ->
  check projectId, String
  Subjects.find {projectId: projectId}

Meteor.publish 'sources', (projectId) ->
  check projectId, String
  Sources.find {projectId: projectId}

Meteor.publish 'subject_source_ids', (projectId) ->
  check projectId, String
  SubjectSourceIds.find {projectId: projectId}

Meteor.publish 'metrics', (projectId) ->
  check projectId, String
  Metrics.find {projectId: projectId}

Meteor.publish 'measurements', (projectId) ->
  check projectId, String
  Measurements.find {projectId: projectId}

Meteor.publish 'notifications', ->
  Notifications.find {userId: this.userId}

Meteor.publish 'usernames', ->
  Meteor.users.find {}, {fields: {'username': 1, '_id': 1, 'show_tip': 1}}
