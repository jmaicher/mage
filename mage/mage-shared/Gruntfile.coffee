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


    # -- clean ----------------------------------------

    clean: {
      dist:
        files:
          src: [
            '<%= config.dist %>'
          ]
    }


    # -- coffee---------------------------------------


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

    copy: {
      dist:
        expand: true
        dot: true
        cwd: '<%= config.src %>'
        dest: '<%= config.dist %>'
        src: [
          'vendor/scripts/**/*.js'
        ]
    }

    bower: {
      install:
        options:
          targetDir: '<%= config.src %>/vendor'
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
    'clean:dist'
    'copy:dist'
    'coffee'
    'watch'
  ]

  grunt.registerTask 'build', [
    'clean:dist'
    'copy:dist'
    'coffee'
  ]

  grunt.registerTask 'default', [
    'build'
  ]

