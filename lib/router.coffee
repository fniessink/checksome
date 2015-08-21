Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: -> [Meteor.subscribe('projects'),
              Meteor.subscribe('notifications'),
              Meteor.subscribe('usernames')]

Router.route '/projects/:_id',
  name: 'projectPage'
  data: -> Projects.findOne this.params._id
  waitOn: ->
    projectId = this.params._id
    [Meteor.subscribe('subjects', projectId),
     Meteor.subscribe('sources', projectId),
     Meteor.subscribe('subject_source_ids', projectId)]

Router.route '/', name: 'home'

requireLogin = ->
  if Meteor.user()
    this.next()
  else
    this.render(if Meteor.loggingIn() then this.loadingTemplate else 'accessDenied')

Router.onBeforeAction requireLogin
