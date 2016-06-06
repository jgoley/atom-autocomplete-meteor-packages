fs         = require 'fs'
{ filter } = require 'fuzzaldrin'

provider =
  selector: '.source.js, .source.coffee'
  disableForSelector: '.source.js .comment'
  inclusionPriority: 1
  filterSuggestions: false

  cachedSuggestions: null
  currentFileName: null

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    @currentFileName = editor.getFileName()
    if @getPrefix editor, bufferPosition, scopeDescriptor.scopes[0]
      if @checkPrefix prefix
        @filterPackages prefix
      else
        @loadMeteorPackages prefix

  getSourceFile: ->
    atom.config.get 'autocomplete-meteor-packages.sourceFile'

  loadMeteorPackages: (prefix) ->
    new Promise (resolve) =>
      projectPath = atom.project.getPaths()[0]
      filePath = "#{projectPath}/.meteor/#{@getSourceFile()}"
      meteorPackages = @parseSourceFile fs.readFileSync(filePath)
      suggestions = @buildSuggestions meteorPackages
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
      userAndName = name.split ':'
      unless userAndName[1] then userAndName.unshift 'meteor'
      link = "https://atmospherejs.com/#{userAndName[0]}/#{userAndName[1]}"
      suggestions.push
        text: if @isPackageJS() then "'#{name}'" else "'meteor/#{name}'"
        displayText: name
        iconHTML: '<i class="icon-telescope"></i>'
        description: if version then "Version: #{version}"
        descriptionMoreURL: link
    suggestions

  parseSourceFile: (file)->
    file
      .toString()
       # Remove single line comments, whitespace and empty lines
      .replace(/#.*/g, '')
      .replace(/^(?=\n)$|^\s*|\s*$|\n\n+/gm, '')
      .split '\n'

  filterPackages: (prefix) ->
    filteredSuggestions = filter @cachedSuggestions, prefix, key: 'displayText'
    filteredSuggestions.map (suggestion) ->
      suggestion.replacementPrefix = prefix
      suggestion

  isPackageJS: ->
    @currentFileName is 'package.js'

  getPrefix: (editor, bufferPosition, scope) ->
    regex =
      if @isPackageJS() then /use\(/g else /require |require\(|from /
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(regex)?[0] or ''

  checkPrefix: (prefix) ->
    prefix.trim() and not prefix.match /\(|\[/

  dispose: ->
    @cachedSuggestions = null
    @currentFileName = null

module.exports = provider
