fs = require 'fs'


provider =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'
  inclusionPriority: 1
  excludeLowerPriority: true
  filterSuggestions: true

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    scope = scopeDescriptor.scopes[0]
    linePrefix = @getPrefix(editor, bufferPosition, scope)

    if linePrefix
      @loadMeteorPackages(linePrefix, prefix, scope)

  loadMeteorPackages: (linePrefix, prefix, scope) ->
    new Promise (resolve) =>
      path = atom.project.getPaths()
      file = "#{path}/.meteor/versions"
      meteorPackages = fs.readFileSync(file).toString().split '\n'
      closeLine = if @checkScope(scope, prefix) then ');' else ''
      suggestions = []
      meteorPackages.forEach (meteorPackage) ->
        packageName = meteorPackage.replace /@.*/, ''
        suggestions.push
          text: "'meteor/#{packageName}'#{closeLine}"
          displayText: packageName
      resolve(suggestions)

  getPrefix: (editor, bufferPosition, scope) ->
    if scope.match /coffee$/
      regex = /require|from/
    else
      regex = /require\(|from/
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(regex)?[0] or ''

  checkScope: (scope, prefix) ->
    scope.match(/js$/) or prefix == '('

module.exports = provider
