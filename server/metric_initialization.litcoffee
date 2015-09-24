Add metrics to projects when necessary.

    if Meteor.isServer
      Meteor.startup ->
        for project in Projects.find().fetch()
          createMetrics project
