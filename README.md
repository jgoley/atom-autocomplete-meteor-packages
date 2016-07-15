# Atom autocomplete for Meteor packages

![Animated gif of auto-completion](http://photog.jonathangoley.com/images/autocomplete_v1.3.gif)


Reads `versions` or `packages` file in Meteor projects and offers autocomplete suggestions when importing Meteor packages (using `require` or `import`) or including packages in `package.js` with `api.use(...`. The package name is automatically prepended with `meteor/` when importing.

Suggestions are also offered in css compilers (.sass, .scss, .less and .styl) after `@import '`. Packages are automatically enclosed in curly brackets like so `@import '{user:package}/...`. ([docs about import css files](https://guide.meteor.com/build-tool.html#css-importing))

The default source file is `versions` (includes all user-added and core Meteor packages) but if you want to only source the user-added packages, change the 'Source file for package names' setting to `packages`.

If your `.meteor` directory is typically not in your project's root directory, you can configure this package to either search for it within your project or supply a custom location.

Meteor is pretty cool, you should [check it out](http://meteor.com/).

### TODO
- Implement file autocomplete when adding files/assets to packages
- Filename autocomplete when importing files from packages in css compilers
