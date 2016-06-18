config =
  sourceFile:
    description: 'Source file for package names'
    type: 'string'
    default: 'versions'
    enum: [
      'versions'
      'packages'
    ]
    order: 1

  meteorDirLocation:
    description: 'Location of `.meteor` directory in current project.
                  If *search* is selected, a recursive search for a `.meteor`
                  directory occurs when the package is loaded'
    type: 'string'
    default: 'projectRoot'
    enum: [
      'projectRoot'
      'search'
    ]
    order: 2

  customMeteorDirLocation:
    description: 'Custom `.meteor` directory location in current project.
                  This will override "Meteor Dir Location" settings.<br/>
                  (relative to your project\'s root e.g. `/app/`)<br/>
                  **No need to add `.meteor`**'
    type: 'string'
    default: ''
    order: 3

module.exports = config
