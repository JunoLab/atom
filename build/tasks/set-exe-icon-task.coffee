path = require 'path'

module.exports = (grunt) ->
  grunt.registerTask 'set-exe-icon', 'Set icon of the exe', ->
    done = @async()

    channel = grunt.config.get('atom.channel')
    shellAppDir = grunt.config.get('atom.shellAppDir')
    shellExePath = path.join(shellAppDir, 'juno.exe')
    iconPath = path.resolve('resources', 'app-icons', channel, 'juno.ico')

    rcedit = require('rcedit')
    rcedit(shellExePath, {'icon': iconPath}, done)
