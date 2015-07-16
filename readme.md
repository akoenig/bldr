# bldr

_pronounced: builder_

`bldr` helps you build your project in an isolated environment without poluting your machine with the respective build tools.

## Abstract

Committing built resources into the VCS like transpiled and minified JavaScript is a huge pain when it comes to merging feature requests. Let's face it: built resources **SHOULD NOT** be in the VCS anyway. `bldr` helps you with that. It performs the build process in an isolated mini-container and writes it into your project directory.

## Workflow

```sh
cd your-project

# Fetch the recent version of the project (which does not contain the built files)
git pull --rebase origin master

bldr
```

## Usage

Configure the respective build command in your projects `package.json`, e.g.

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

Consider the `build` attribute in the `package.json`. This will tell `bldr` which command should be executed.

## TODO

  * Build the chroot after installing `bldr` as `prepublish` hook.

## Specification

Installation directory: /usr/local/bin/bldr
Chroot location: ~/.bldr

Dependencies: debootstrap schroot

schroot configuration `/etc/schroot/schroot.conf`

```sh
[bldr]
description=bldr environment
type=directory
directory=/home/<username>/.bldr
users=<username>
```

## Author

Copyright 2015, [André König](http://andrekoenig.info) (andre.koenig@posteo.de)
