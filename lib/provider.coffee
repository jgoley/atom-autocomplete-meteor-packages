fs         = require 'fs'
{ filter } = require 'fuzzaldrin'

provider =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'
  inclusionPriority: 1
  excludeLowerPriority: false
  filterSuggestions: false

  cachedSuggestions: null

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    scope = scopeDescriptor.scopes[0]
    linePrefix = @getPrefix editor, bufferPosition, scope
    if linePrefix
      if prefix.trim() and prefix != '('
        @filterPackages prefix
      else
        @loadMeteorPackages prefix

  getSourceFile: ->
    atom.config.get 'autocomplete-meteor-packages.sourceFile'

  loadMeteorPackages: (prefix) ->
    new Promise (resolve) =>
      sourceFile = @getSourceFile()
      projectPath = atom.project.getPaths()[0]
      filePath = "#{projectPath}/.meteor/#{sourceFile}"
      meteorPackages = @parseSourceFile fs.readFileSync(filePath)
      suggestions = @buildSuggestions(meteorPackages)
      @cachedSuggestions = suggestions
      resolve suggestions

  buildSuggestions: (meteorPackages) ->
    suggestions = []
    meteorPackages.forEach (meteorPackage) =>
      if @getSourceFile() is 'versions'
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

  parseSourceFile: (file)->
    file
      .toString()
       # Remove single line comments, whitespace and empty lines
      .replace(/#.*/g, '')
      .replace(/^(?=\n)$|^\s*|\s*$|\n\n+/gm, '')
      .split '\n'

  filterPackages: (prefix) ->
    filter @cachedSuggestions, prefix, key: 'displayText'

  getPrefix: (editor, bufferPosition, scope) ->
    regex = /require |require\(|from /
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(regex)?[0] or ''

  dispose: ->
    @cachedSuggestions = null

module.exports = provider
