getPath = new Promise (resolve) ->
  packageName      = 'autocomplete-meteor-packages'
  projectRoot      = atom.project.getPaths()[0]
  meteorDirSetting = 'search' # Use settings

  switch meteorDirSetting
    when 'search'
      find = require 'find'
      find.dir /\.meteor$/, projectRoot, (dirs) ->
        meteorPath = if dirs[0] then dirs[0]
        resolve meteorPath
    when 'custom'
      customDirLocation =
        atom.config.get "#{packageName}.customDirLocation"
      meteorPath = "#{projectRoot}/#{customDirLocation}"
      resolve meteorPath
    when 'root'
      rootLocation = "#{projectRoot}/.meteor"
      fs = require 'fs'
      if fs.existsSync rootLocation
        meteorPath = rootLocation
      resolve meteorPath

module.exports = getPath
