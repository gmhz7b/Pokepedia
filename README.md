![icon](./Pokepedia/Assets.xcassets/icon.imageset/icon.png)

# Poképedia

The base project file for UMSL CS 4220 2021 summer semester projects.

### Objectives

It is far more common to encounter pre-existing applications rather than creating new ones 
(aka greenfield apps). The projects for this course are meant to simulate an environment where
programmers will need to integrate-with and enhance an existing code base. To do this, students
must:
* Be able to read and understand local (app/client-side) and remote (server-side) data models.

* Apply concepts learned in course lectures and activities to implement new features into the app.

### Expectations

Students are expected to complete project requirements within the app itself. The application 
provides several swift package dependencies that were developed specifically with this project in mind.
The packages exist to provide encapsulation between the pre-supplied code, and the code students will 
be implementing as part of new enhancements.

### Appflow

* A user launches the app.

* A searchable-list of Pokémon appears.

* The user taps on a Pokémon's name.

* A `UIMenu` displays options for various details about the selected Pokémon that the user may view.

* The user selects a `UIMenuElement`.

* The app shows details about the selected Pokémon pertinent to the `UIMenuElement` chosen.

### Notes

* `ctrl + cmd + click`  on an object to navigate to its residing file.

* `option + click` on an object to see documentation.

* A __SwiftLint__ build script has been added for convenience.

* `TODO` and `FIXME` will compile as warnings in the issue navigator.

### Just for Fun

* To add __PokémonCryKit__ to this project: 
    * Select `Pokepedia(project file)~>Pokepedia(project tab)~>Swiift Packages~>+`.
    * Copy and paste the following in the search bar: [https://github.com/gmhz7b/PokemonCryKit.git](https://github.com/gmhz7b/PokemonCryKit.git)
    * Select "Up to Next Major" with "1.0.0" as the value specified.
    * Click "Next".
    * Click "Finish".
    * See [PokemonCryProvider.swift](https://github.com/gmhz7b/PokemonCryKit/blob/master/Sources/PokemonCryKit/PokemonCryProvider.swift) for usage details.
