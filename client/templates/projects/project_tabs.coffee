Template.projectTabs.onCreated ->
  Session.setDefault 'currentProjectTab', 'source'

Template.projectTabs.onRendered ->
  current = this.$('a[href="#' + Session.get('currentProjectTab') + '"]')
  current.tab 'show'

Template.projectTabs.events
  'shown.bs.tab': (e) ->
    Session.set 'currentProjectTab', e.target.href.split('#')[1]
  'click .add-kind': (e) ->
    start_submitting Session.get 'currentProjectTab'

Template.projectTabs.helpers
  sources_count: -> Sources.find().count()
  subjects_count: -> Subjects.find().count()
  translated_kind: -> TAPi18n.__ Session.get 'currentProjectTab'
  can_add_item: ->
    currentTab = Session.get 'currentProjectTab'
    if currentTab == 'report'
      return false
    if currentTab == 'subject' and Sources.find().count() == 0
      return false
    return true
