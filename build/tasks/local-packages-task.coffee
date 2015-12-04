fs = require 'fs'
path = require 'path'

module.exports = (grunt) ->
  {cp, rm} = require('./task-helpers')(grunt)
  home = process.env.USERPROFILE or process.env.HOME

  local = [
    'julia-client'
    'ink'
  ]

  grunt.registerTask 'local-packages', ->
    for pkg in local
      pjs = fs.readFileSync path.join('node_modules', pkg, 'package.json')
      rm path.join('node_modules', pkg)
      cp path.join(home, '.atom', 'packages', pkg), path.join('node_modules', pkg)
      fs.writeFileSync path.join('node_modules', pkg, 'package.json'), pjs
