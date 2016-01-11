module.exports = (grunt) ->
  {cp} = require('./task-helpers')(grunt)
  grunt.registerTask 'copy-julia', ->
    shellAppDir = grunt.config.get('atom.shellAppDir')
    ver = grunt.option 'julia-version'

    if process.platform is 'darwin'
      cp "julia/julia-#{ver}-mac", "#{shellAppDir}/Contents/Resources/julia"
      cp "julia/pkg", "#{shellAppDir}/Contents/Resources/julia/pkg"

    else if process.platform is 'win32'
      cp "julia/julia-#{ver}-win64", "#{shellAppDir}/resources/julia"
      cp "julia/pkg", "#{shellAppDir}/resources/julia/pkg"
