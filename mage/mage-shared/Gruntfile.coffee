"use strict"

module.exports = (grunt) ->

  require('jit-grunt')(grunt, {
    useminPrepare: 'grunt-usemin',
    bower: 'grunt-bower-task'
  })({
    pluginsRoot: '../node_modules'
  })
  
  grunt.initConfig {

    config: {
      src: 'src',
      dist: 'dist/shared'
    }

    watch: {
      coffee:
        files: ['<%= config.src %>/scripts/{,*/}*.coffee']
        tasks: ['newer:coffee:dist']
    }

    coffee: {
      options:
        sourceMap: true
        sourceRoot: ''
      dist:
        expand: true
        cwd: '<%= config.src %>/scripts'
        src: '{,*/}*.coffee'
        dest: '<%= config.dist %>/scripts'
        ext: '.js'
    }

    bower: {
      install:
        options:
          targetDir: '<%= config.dist %>/vendor'
          layout: (type, component) ->
            type_dir = switch type
              when 'js' then 'scripts'
              when 'css' then 'styles'
              when 'img' then 'images'
              else type
            
            require('path').join(type_dir, component)
    }

  } # grunt.initConfig

  grunt.registerTask 'dev', [
    'coffee'
    'watch'
  ]

  grunt.registerTask 'dist', [
    'coffee'
  ]

  grunt.registerTask 'default', [
    'dist'
  ]

