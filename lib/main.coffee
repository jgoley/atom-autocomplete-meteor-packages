config                 = require './config'
MeteorPackagesProvider = require './provider'
packageName = 'autocomplete-meteor-packages'
configProps = [
  "#{packageName}.customMeteorDirLocation"
  "#{packageName}.meteorDirLocation"
]

module.exports =
  config: config

  disposables: []

  registerEvents: ->
    for prop in configProps
      @disposables.push atom.config.observe prop, (value) =>
        @provider?.findMeteor()

  activate: ->
    @registerEvents()

  provide: ->
    @provider = new MeteorPackagesProvider()
    @provider

  deactivate: ->
    for disposable in @disposables
      disposable.dispose()
    @provide = null
    @provider = null
