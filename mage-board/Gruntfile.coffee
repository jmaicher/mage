"use strict"

module.exports = (grunt) ->
  
  require('jit-grunt')(grunt, { # static mappings
    useminPrepare: 'grunt-usemin'
  })

  components =
    scripts: [
      '<%= config.app %>/components/jquery/dist/jquery.js'
      '<%= config.app %>/components/lodash/dist/lodash.js'
      '<%= config.app %>/components/sockjs/sockjs.js'
      '<%= config.app %>/components/angular/angular.js'
      '<%= config.app %>/components/angular-route/angular-route.js'
      '<%= config.app %>/components/angular-animate/angular-animate.js'
      '<%= config.app %>/components/angular-resource/angular-resource.js'
    ]
  
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
        tasks: [] # ['karma:watch:run']
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
        port: 8000
        hostname: '0.0.0.0'
        livereload: 8888
      dev:
        options:
          base: [
            '<%= config.tmp %>'
            '<%= config.app %>'
          ]
      dist:
        options:
          livereload: false
          base: '<%= config.dist %>'
    }

    # -- usemin ---------------------------------------

    useminPrepare: {
      html: '<%= config.app %>/index.html'
      options:
        dest: '<%= config.dist %>'
    }

    usemin: {
      html: ['<%= config.dist %>/{,*/}*.html'],
      css: ['<%= config.dist %>/styles/{,*/}*.css'],
      options:
        assetsDirs: ['<%= config.dist %>']
    }

    uglify: {
      options:
        mangle: false
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
        src: 'app.js'
        dest: '<%= config.tmp %>/concat/scripts'
    }


    # -- copy ----------------------------------------

    copy: {
      components:
        files: [
          {
            expand: true
            flatten: true
            src: components.scripts
            dest: '<%= config.tmp %>/scripts/vendor/'
          }
        ]
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
          'fonts/**/*.{eot,svg,ttf,woff}'
        ]
    }

 
    # -- rev -----------------------------------------

    rev: {
      src: [
        '<%= config.dist %>/scripts/{,*/}*.js'
        '<%= config.dist %>/styles/{,*/}*.css'
        #'<%= config.dist %>/views/{,*/}*.html'
        '<%= config.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        '<%= config.dist %>/fonts/**/*.{eot,svg,ttf,woff}'
      ]
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
    'copy:components'
    'connect:dev'
    #'karma:watch:start'
    'watch'
  ]

  grunt.registerTask 'test', [
    'clean:server'
    'coffee'
    'sass'
    'copy:components'
    'karma:unit'
  ]

  grunt.registerTask 'build', [
    'clean:dist'
    'useminPrepare'
    'coffee'
    'sass'
    'copy:components'
    'concat'
    'ngmin'
    'cssmin'
    'uglify'
    'copy:dist'
    'rev'
    'usemin'
  ]

  grunt.registerTask 'default', [
    'test'
    'build'
  ]

