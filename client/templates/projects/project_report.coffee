Template.projectSourcesTable.helpers
  sources: -> Sources.find {}, {sort: {position: 1}}
  has_sources: -> Sources.find().count() > 0

Template.projectSubjectsTable.helpers
  subjects: -> Subjects.find {}, {sort: {position: 1}}
  has_subjects: -> Subjects.find().count() > 0
  subjectSources: -> Sources.find {_id: {$in: this.sources or []}}
