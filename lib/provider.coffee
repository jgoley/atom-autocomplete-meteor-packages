fs         = require 'fs'
{ filter } = require 'fuzzaldrin'


provider =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'
  inclusionPriority: 1
  excludeLowerPriority: false
  filterSuggestions: false

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    scope = scopeDescriptor.scopes[0]
    linePrefix = @getPrefix editor, bufferPosition, scope
    if linePrefix
      if prefix and prefix != '('
        @filterPackages prefix
      else
        @loadMeteorPackages prefix

  loadMeteorPackages: (prefix) ->
    new Promise (resolve) ->
      path = atom.project.getPaths()
      file = "#{path}/.meteor/versions"
      meteorPackages = fs.readFileSync(file).toString().split '\n'
      suggestions = []
      meteorPackages.forEach (meteorPackage) ->
        meteorPackage = meteorPackage.split '@'
        name = meteorPackage[0]
        version = meteorPackage[1]
        suggestions.push
          text: "'meteor/#{name}'"
          displayText: name
          description: "Version: #{version}"
          iconHTML: '<i class="icon-telescope"></i>'
      resolve(suggestions)

  filterPackages: (prefix) ->
    @loadMeteorPackages(prefix)
      .then (packages) ->
        filter packages, prefix, key: 'displayText'

  getPrefix: (editor, bufferPosition, scope) ->
    regex = /require |require\(|from /
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(regex)?[0] or ''

module.exports = provider
