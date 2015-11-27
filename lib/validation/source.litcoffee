A `source` is valid if it has a url and is a valid item.

    @validateSource = (source) ->

First, check that the item has the right structure and is a valid item.

      check source, Match.ObjectIncluding
        type: String
        url: String
        username: String
        password: String
      validateItem source

Then, check that a type is present.

      if source.type == ''
        throw new Meteor.Error('invalid-source', 'You must add a type to a source')

Next, check that a url is present.

      if source.url == ''
        throw new Meteor.Error('invalid-source', 'You must add a url to a source')
