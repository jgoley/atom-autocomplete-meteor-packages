getMeteorPath = () ->
  { meteorDirLocation, customMeteorDirLocation } = getPathSettings()
  new Promise (resolve) ->
    projectRootDir = atom.project.getPaths()[0]
    if customMeteorDirLocation then meteorDirLocation = 'custom'
    switch meteorDirLocation
      when 'search'
        find = require 'find'
        find.dir /\.meteor$/, projectRootDir, (dirs) ->
          meteorPath = if dirs[0] then dirs[0]
          resolve meteorPath
      when 'custom'
        meteorPath = "#{projectRootDir}#{customMeteorDirLocation}.meteor"
        resolve meteorPath
      when 'projectRoot'
        rootLocation = "#{projectRootDir}/.meteor"
        fs = require 'fs'
        if fs.existsSync rootLocation
          meteorPath = rootLocation
        resolve meteorPath

getPathSettings = () ->
  packageName = 'autocomplete-meteor-packages'
  meteorDirLocation      : atom.config.get "#{packageName}.meteorDirLocation"
  customMeteorDirLocation: atom.config.get "#{packageName}.customMeteorDirLocation"

module.exports =
  getMeteorPath  : getMeteorPath
  getPathSettings: getPathSettings
