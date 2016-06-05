fs         = require 'fs'
{ filter } = require 'fuzzaldrin'


provider =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'
  inclusionPriority: 1
  excludeLowerPriority: false
  filterSuggestions: false

  getSourceFile: ->
    atom.config.get 'autocomplete-meteor-packages.sourceFile'

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    scope = scopeDescriptor.scopes[0]
    linePrefix = @getPrefix editor, bufferPosition, scope
    if linePrefix
      if prefix and prefix != '('
        @filterPackages prefix
      else
        @loadMeteorPackages prefix

  loadMeteorPackages: (prefix) ->
    new Promise (resolve) =>
      sourceFile = @getSourceFile()
      projectPath = atom.project.getPaths()[0]
      file = "#{projectPath}/.meteor/#{sourceFile}"
      suggestions = []
      meteorPackages =
        fs.readFileSync(file)
          .toString()
          .replace(/^(?=\n)$|^\s*|\s*$|\n\n+/gm,"")
          .split '\n'
      meteorPackages.forEach (meteorPackage) ->
        if sourceFile is 'versions'
          meteorPackage = meteorPackage.split '@'
          name = meteorPackage[0]
          version = meteorPackage[1]
        else
          name = meteorPackage
        suggestions.push
          text: "'meteor/#{name}'"
          displayText: name
          description: if version then "Version: #{version}"
          iconHTML: '<i class="icon-telescope"></i>'
        suggestions
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
