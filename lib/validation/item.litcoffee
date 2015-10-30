To **validate items** we check that they have a `title` and an optional
`description`.

Items can both be containers like projects, as well as
singular items such as sources and subjects.

    @validateItem = (item) ->

First, check that the item has the right structure.

      check item, Match.ObjectIncluding
        title: String
        description: Match.Optional(String)

Then, check that a title is present.

      if item.title == ''
        throw new Meteor.Error('invalid-item', 'You must add a title to an item')
