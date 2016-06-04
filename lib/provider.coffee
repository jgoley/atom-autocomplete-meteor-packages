fs = require('fs')

provider =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'

  inclusionPriority: 1
  excludeLowerPriority: true
  filterSuggestions: true

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    # Load meteor packages

module.exports = provider
