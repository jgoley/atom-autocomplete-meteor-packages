# Atom autocomplete for Meteor packages

![Animated gif of auto-completion](http://photog.jonathangoley.com/images/autocomplete-with-packagesJs.gif)


Reads `versions` or `packages` file in Meteor projects and offers autocomplete suggestions when importing Meteor packages (using `require` or `import`) or including packages in `package.js` with `api.use(...`. The package name is automatically prepended with `meteor/` when importing.

The default source file is `versions` (includes all user-added and core Meteor packages) but if you want to only source the user-added packages, change the 'Source file for package names' setting to `packages`.

If your `.meteor`directory is typically not in your project's root dir, you can configure this package to either search for it withing your project or supply a custom location.

Meteor is pretty cool, you should [check it out](http://meteor.com/).

### TODO
Implement autocomplete when importing stylus/less/sass files from packages (e.g `@import {name:package}/file`)
