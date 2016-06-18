config                 = require './config'
MeteorPackagesProvider = require './provider'

module.exports =
  config: config

  provide: ->
    provider = new MeteorPackagesProvider()
    provider

  deactivate: ->
    @provide = null
