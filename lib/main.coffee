config                 = require './config'
MeteorPackagesProvider = require './provider'
getMeteorPath          = require './path'

module.exports =
  config: config

  activate: ->
    getMeteorPath
      .then (path) =>
        unless path
          @deactivate()

  provide: ->
    new MeteorPackagesProvider()

  deactivate: ->
    delete @provide
