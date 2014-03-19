"use strict"

module.exports = (grunt) ->
  
  require('jit-grunt')(grunt)
  
  grunt.initConfig {
    
    config: {
      app: 'app'
      dist: 'dist'
      test: 'test'
      tmp: '.tmp'
    }

 
    # -- watch ----------------------------------------
    
    watch: {
      coffee:
        files: ['<%= config.app %>/scripts/{,*/}*.coffee']
        tasks: ['newer:coffee:dist']
      coffeeTest:
        files: ['<%= config.test %>/spec/{,*/}*.coffee']
        tasks: ['newer:coffee:test']
      karma:
        files: [
          '<%= config.tmp %>/scripts/{,*/}*.js'
          '<%= config.tmp %>/spec/{,*/}*.js'
        ]
        tasks: ['karma:watch:run']
      styles:
        files: ['<%= config.app %>/styles/{,*/}*.scss']
        tasks: ['newer:sass']
      gruntfile:
        files: ['Gruntfile.coffee']
      livereload:
        options:
          livereload: '<%= connect.options.livereload %>'
        files: [
          '<%= config.app %>/{,*/}*.html'
          '<%= config.tmp %>/styles/{,*/}*.css'
          '<%= config.tmp %>/scripts/{,*/}*.js'
          '<%= config.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
    }


    # -- connect --------------------------------------
    
    connect: {
      options:
        port: 4000
        hostname: '0.0.0.0'
        livereload: 4444
      livereload:
        options:
          base: [
            '<%= config.tmp %>'
            '<%= config.app %>'
          ]
      test:
        options:
          port: 9000
          base: [
            '<%= config.tmp %>'
            '<%= config.app %>'
            '<%= config.test %>'
          ]
      dist:
        options:
          base: '<%= config.dist %>'
    }


    # -- clean ----------------------------------------

    clean: {
      dist:
        files:
          src: [
            '<%= config.dist %>'
            '<%= config.tmp %>'
          ]
      server: '<%= config.tmp %>'
    }


    # -- coffee---------------------------------------

    coffee: {
      options:
        sourceMap: true
        sourceRoot: ''
      dist:
        expand: true
        cwd: '<%= config.app %>/scripts'
        src: '{,*/}*.coffee'
        dest: '<%= config.tmp %>/scripts'
        ext: '.js'
      test:
        expand: true
        cwd: '<%= config.test %>/spec'
        src: '{,*/}*.coffee'
        dest: '<%= config.tmp %>/spec'
        ext: '.js'
    }


    # -- sass ----------------------------------------

    sass: {
      options:
        sourcemap: true
      dist:
        expand: true
        cwd: '<%= config.app %>/styles'
        src: ['{,*/}*.scss']
        dest: '<%= config.tmp %>/styles'
        ext: '.css'
    }


    # -- ngmin ---------------------------------------

    ngmin: {
      dist:
        expand: true
        cwd: '<%= config.tmp %>/concat/scripts'
        src: '*.js'
        dest: '<%= config.tmp %>/concat/scripts'
    }


    # -- copy ----------------------------------------

    copy: {
      dist:
        expand: true
        dot: true
        cwd: '<%= config.app %>'
        dest: '<%= config.dist %>'
        src: [
          '*.{ico,png,txt}'
          '*.html'
          'views/{,*/}*.html'
          'images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
    }

 
    # -- rev -----------------------------------------

    rev: {
      src: ['<%= config.dist %>/**/*.{js,css,png,jpg}']
    }


    # -- karma ---------------------------------------

    karma: {
      options:
        configFile: 'karma.conf.js'
      watch:
        background: true
      unit:
        singleRun: true
    }

  }

  grunt.registerTask 'dist', [
    'build'
    'connect:dist:keepalive'
  ]

  grunt.registerTask 'dev', [
    'clean:server'
    'coffee'
    'sass'
    'connect:livereload'
    'karma:watch:start'
    'watch'
  ]

  grunt.registerTask 'test', [
    'clean:server'
    'coffee'
    'sass'
    'karma:unit'
  ]

  grunt.registerTask 'build', [
    'clean:dist'
    'coffee'
    'sass'
    # 'concat'
    # 'ngmin'
    'copy:dist'
    # 'uglify'
    # 'rev'
    # 'usemin'
  ]

  grunt.registerTask 'default', [
    'test'
    'build'
  ]

