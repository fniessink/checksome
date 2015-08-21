title_error =
  title: jasmine.any(String)

url_error =
  url: jasmine.any(String)


describe 'An item', ->

  it 'is valid when it has a title', ->
    expect(validateItem({title: 'Title'})).toEqual {}

  it 'is valid when it has a title and a description', ->
    expect(validateItem({title: 'Title', 'description': 'Description'})).toEqual {}

  it 'is invalid when it has an empty title', ->
    expect(validateItem({title: ''})).toEqual title_error

  it 'is invalid when it had no title', ->
    expect( -> validateItem({})).toThrowError Match.Error

  it 'is invalid when the title is not a string', ->
    expect( -> validateItem({title: 10})).toThrowError Match.Error

  it 'is invalid when the description is not a string', ->
    expect( -> validateItem({title: 'Title', 'description': 10})).toThrowError Match.Error


describe 'A project', ->

  beforeEach ->
    this.project =
      title: 'Title'
      members: ['Dummy user']

  it 'is valid when it has a title and at least one project member', ->
    expect(validateProject(this.project)).toEqual {}

  it 'is invalid when it has no title', ->
    this.project.title = ''
    expect(validateProject(this.project)).toEqual title_error

  it 'is invalid when it has no members', ->
    this.project.members = []
    expect(validateProject(this.project)).toEqual
      members: jasmine.any(String)

  it 'is invalid when it has no title and no members', ->
    this.project.title = ''
    this.project.members = []
    expect(validateProject(this.project)).toEqual
      title: jasmine.any(String)
      members: jasmine.any(String)

  it 'is invalid when the members is not an array of strings', ->
    this.project.members = [10]
    expect( -> validateItem(this.project)).toThrowError Match.Error


describe 'A source', ->

  beforeEach ->
    this.source =
      title: 'Title'
      url: 'http://url'

  it 'is valid when it has a title, a url, and a project id', ->
    expect(validateSource(this.source)).toEqual {}

  it 'is invalid when it has no title', ->
    this.source.title = ''
    expect(validateSource(this.source)).toEqual title_error

  it 'is invalid when it has no url', ->
    this.source.url = ''
    expect(validateSource(this.source)).toEqual url_error


describe 'A subject', ->

  beforeEach ->
    this.subject =
      title: 'Title'
      sources: ['Dummy source']

  it 'is valid when it has a title and at least one source', ->
    expect(validateSubject(this.subject)).toEqual {}

  it 'is invalid when it has no title', ->
    this.subject.title = ''
    expect(validateSubject(this.subject)).toEqual title_error

  it 'is invalid when it has no sources', ->
    this.subject.sources = []
    expect(validateSubject(this.subject)).toEqual
      sources: jasmine.any(String)

  it 'is invalid when it has no title and no sources', ->
    this.subject.title = ''
    this.subject.sources = []
    expect(validateSubject(this.subject)).toEqual
      title: jasmine.any(String)
      sources: jasmine.any(String)

  it 'is invalid when the sources are not an array of strings', ->
    this.subject.sources = [10]
    expect( => validateSubject(this.subject)).toThrowError Match.Error
