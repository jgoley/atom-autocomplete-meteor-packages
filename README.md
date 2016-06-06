# Atom autocomplete for Meteor packages

![Animated gif of auto-completion](http://photog.jonathangoley.com/images/autocomplete-5.gif)


Reads `versions` or `packages` file in Meteor projects and offers autocomplete suggestions when importing Meteor packages (using `require` or `import`) or including packages in `package.js` with `api.use(...`. The package name is automatically prepended with `meteor/` when importing.

The default source file is `versions` (includes all user-added and core Meteor packages) but if you want to only source the user-added packages, change the 'Source file for package names' setting to `packages`.

Meteor is pretty cool, you should [check it out](http://meteor.com/).
