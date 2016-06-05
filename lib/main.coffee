fs       = require 'fs'
provider = require './provider'

module.exports =
  config:
    sourceFile:
      title: 'Source file for package names'
      type: 'string'
      default: 'versions'
      enum: [
        'versions'
        'packages'
      ]

  activate: ->
    path = atom.project.getPaths()[0]
    if fs.existsSync "#{path}/.meteor"
      @provide = -> provider

  deactivate: ->
    @provider.dispose()
