# bldr

_pronounced: builder_

`bldr` helps you build your project in an isolated environment without poluting your machine with the respective build tools.

## Abstract

Committing built resources into the VCS, like transpiled and minified JavaScript, is a huge pain when it comes to merging feature requests. Let's face it: built resources **SHOULD NOT** be in the VCS anyway. `bldr` helps you with that. It performs the build process in an isolated mini-container and writes the result straight into your project directory.

## Installation

```sh
git clone https://github.com/akoenig/bldr

cd bldr
sudo make install
```

`bldr` ships with a default configuration which can be overwritten by defining them as environment variables when executing the respective `make` task:

```sh
sudo make install BOX_SOURCE=http://host.tld/path/to/a/provisioning/script
```

### Available configurations

  * `BASE_BOX`: URL of the base box (default: `http://de.archive.ubuntu.com/ubuntu`)
  * `BASE_BOX_NAME`: Product name of the base box (default: `vivid`)
  * `BASE_BOX_ARCH`: The machine's architecture (default: `amd64`)
  * `BASE_BOX_VARIANT`: The base box variant (default: `buildd`)
  * `BOX_SOURCE`: The box's provisioning script (default: `https://raw.githubusercontent.com/akoenig/bldr/master/boxes/nodejs`).

## Usage

When `bldr` has been installed, the build workflow will look like:

```sh
cd your-project

# Fetch the recent version of the project (which does not contain the built files)
git pull --rebase origin master

bldr
```

## Project configuration

`bldr` scans your project's `package.json` for a `build` attribute which defines the steps that should be executed for building the project. An example:

```json
{
  "name": "foo-project",
  "version": "1.0.0",
  "scripts": {
      "compile": "gulp compile",
      "minify": "gulp minify"
  },
  "build": "npm run compile && npm run minify"
}
```

## Author

Copyright 2015, [André König](http://andrekoenig.info) (andre.koenig@posteo.de)
