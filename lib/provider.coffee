fs            = require 'fs'
{ filter }    = require 'fuzzaldrin'
path          = require './path'

class MeteorPackagesProvider
  selector          : '.source.js, .source.coffee, .source.stylus, .source.scss, .source.sass, .source.less'
  disableForSelector: '.source.js .comment, .source.coffee .comment'
  inclusionPriority : 1
  filterSuggestions : false

  cachedSuggestions : null
  currentFileName   : null
  meteorPath        : null

  constructor: ->
    @findMeteor()

  findMeteor: ->
    path.getMeteorPath()
      .then (meteorPath) =>
        @meteorPath = meteorPath

  getSourceFile: ->
    atom.config.get 'autocomplete-meteor-packages.sourceFile'

  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
    # Do not supply suggestions unless meteor folder exists
    unless @meteorPath then return

    @currentFileName = editor.getFileName()
    scope = scopeDescriptor.scopes[0]
    if @getPrefix editor, bufferPosition, scope
      if @checkPrefix(prefix) and @cachedSuggestions
        @filterPackages prefix
      else
        @loadMeteorPackages prefix, scope

  loadMeteorPackages: (prefix, scope) ->
    new Promise (resolve) =>
      meteorPackagePath = "#{@meteorPath}/#{@getSourceFile()}"
      meteorPackages = @parseSourceFile fs.readFileSync meteorPackagePath
      suggestions = @buildSuggestions meteorPackages, scope
      @cachedSuggestions = suggestions
      resolve suggestions

  buildSuggestions: (meteorPackages, scope) ->
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
        text:
          if @isPackageJS()
            "'#{name}'"
          else if @scopeIsCSS(scope)
            "{#{name}}/"
          else "'meteor/#{name}'"
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

  scopeIsCSS: (scope) ->
    scope.match /css\.|sass/

  getPrefix: (editor, bufferPosition, scope) ->
    regex =
      if @isPackageJS()
        /use\(/g
      else if @scopeIsCSS(scope)
        /^@import ('|")$/
      else
        /require |require\(|from /

    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(regex)?[0] or ''

  checkPrefix: (prefix) ->
    prefix.trim() and not prefix.match /\(|\[/

  dispose: ->
    @cachedSuggestions = null
    @currentFileName   = null
    @getSuggestions    = null
    @selector          = null
    @meteorPath        = null

module.exports = MeteorPackagesProvider
