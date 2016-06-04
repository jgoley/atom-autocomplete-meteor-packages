fs = require 'fs'

provider =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'

  inclusionPriority: 1
  excludeLowerPriority: true
  filterSuggestions: true

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    @loadMeteorPackages(prefix)

  loadMeteorPackages: (prefix) ->
    new Promise (resolve) ->
      path = atom.project.getPaths()
      file = "#{path}/.meteor/versions"
      meteorPackages = fs.readFileSync(file).toString().split '\n'
      suggestions = []
      meteorPackages.forEach (meteorPackage) ->
        packageName = meteorPackage.replace /@.*/, ''
        suggestions.push
          displayText: packageName
          text: "'meteor/#{packageName}'"
      resolve(suggestions)

module.exports = provider
