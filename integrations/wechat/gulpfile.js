/*=====================================
=  Default Configuration For Baocai  =
*   Author ： zhaoqiying
*   Date   ： 2015-05-21
=====================================*/

// Please use config.js to override these selectively:
// 请用config.js选择性的配置
var config = {
  dest: 'www', // 不要更改
  cordova: false,
  minify_images: false,
  
  vendor: {
    js: [
      './bower_components/angular/angular.js',
      './bower_components/angular-route/angular-route.js',
      './bower_components/mobile-angular-ui/dist/js/mobile-angular-ui.js'
    ],

    fonts: [
      './bower_components/font-awesome/fonts/fontawesome-webfont.*'
    ]
  },

  server: {
    host: '127.0.0.1',
    port: '9000'
  },

  weinre: {
    httpPort:     9001,
    boundHost:    'localhost',
    verbose:      false,
    debug:        false,
    readTimeout:  5,
    deathTimeout: 15
  }
};


if (require('fs').existsSync('./config.js')) {
  var configFn = require('./config');
  configFn(config);
}

/*-----  End of Configuration  ------*/


/*========================================
=            Requiring stuffs            =
========================================*/

var gulp           = require('gulp'),
    seq            = require('run-sequence'),
    connect        = require('gulp-connect'),
    less           = require('gulp-less'),
    uglify         = require('gulp-uglify'),
    sourcemaps     = require('gulp-sourcemaps'),
    cssmin         = require('gulp-cssmin'),
    order          = require('gulp-order'),
    concat         = require('gulp-concat'),
    ignore         = require('gulp-ignore'),
    rimraf         = require('gulp-rimraf'),
    imagemin       = require('gulp-imagemin'),
    pngcrush       = require('imagemin-pngcrush'),
    templateCache  = require('gulp-angular-templatecache'),
    mobilizer      = require('gulp-mobilizer'),
    ngAnnotate     = require('gulp-ng-annotate'),
    replace        = require('gulp-replace'),
    ngFilesort     = require('gulp-angular-filesort'),
    streamqueue    = require('streamqueue'),
    rename         = require('gulp-rename'),
    clean          = require('gulp-clean'),
    path           = require('path');


/*================================================
=            Report Errors to Console            =
================================================*/

gulp.on('error', function(e) {
  throw(e);
});


/*=========================================
=            Clean dest folder            =
=========================================*/

gulp.task('clean', function (cb) {
  return gulp.src([
        path.join(config.dest, 'index.html'),
        path.join(config.dest, 'images'),
        path.join(config.dest, 'css'),
        path.join(config.dest, 'js'),
        path.join(config.dest, 'fonts')
      ], { read: false })
     .pipe(rimraf());
});


/*==========================================
=            Start a web server            =
==========================================*/

gulp.task('connect', function() {
  if (typeof config.server === 'object') {
    connect.server({
      root: config.dest,
      host: config.server.host,
      port: config.server.port,
      livereload: true
    });
  } else {
    throw new Error('Connect is not configured');
  }
});


/*==============================================================
=            Setup live reloading on source changes            =
==============================================================*/

gulp.task('livereload', function () {
  gulp.src(path.join(config.dest, '*.html'))
    .pipe(connect.reload());
});


/*=====================================
=            Minify images            =
=====================================*/

gulp.task('images', function () {
  var stream = gulp.src('src/images/**/*');
  
  if (config.minify_images) {
    stream = stream.pipe(imagemin({
        progressive: true,
        svgoPlugins: [{removeViewBox: false}],
        use: [pngcrush()]
    }));
  }
  
  return stream.pipe(gulp.dest(path.join(config.dest, 'images')));
});

/*==================================
=            Copy fonts            =
==================================*/

gulp.task('fonts', function() {
  return gulp.src(config.vendor.fonts)
  .pipe(gulp.dest(path.join(config.dest, 'fonts')));
});


/*=================================================
=            Copy html files to dest              =
=================================================*/

gulp.task('html', function() {
  var inject = [];
  if (typeof config.weinre === 'object') {
    inject.push('<script src="http://'+config.weinre.boundHost+':'+config.weinre.httpPort+'/target/target-script-min.js"></script>');
  }
  if (config.cordova) {
    inject.push('<script src="cordova.js"></script>');
  }
  gulp.src(['src/html/**/*.html'])
  .pipe(replace('<!-- inject:js -->', inject.join('\n    ')))
  .pipe(gulp.dest(config.dest));
});


/*======================================================================
=            Compile, minify, mobilize less                            =
======================================================================*/

gulp.task('less', function () {
  gulp.src(['./src/less/app.less', './src/less/responsive.less'])
    .pipe(less({
      paths: [ path.resolve(__dirname, 'src/less'), path.resolve(__dirname, 'bower_components') ]
    }))
    .pipe(mobilizer('app.css', {
      'app.css': {
        hover: 'exclude',
        screens: ['0px']      
      },
      'hover.css': {
        hover: 'only',
        screens: ['0px']
      }
    }))
    .pipe(cssmin())
    .pipe(rename({suffix: '.min'}))
    .pipe(gulp.dest(path.join(config.dest, 'css')));
});


/*====================================================================
=            Compile and minify js generating source maps            =
====================================================================*/
// - Orders ng deps automatically
// - Precompile templates to ng templateCache

gulp.task('js', function() {
    streamqueue({ objectMode: true },
      gulp.src(config.vendor.js),
      gulp.src('./src/js/core.js'),
      gulp.src('./src/js/alloy/*.js').pipe(ngFilesort()),
      gulp.src('./src/js/directives/*.js').pipe(ngFilesort()),
      gulp.src('./src/js/filters/*.js').pipe(ngFilesort()),
      gulp.src('./src/js/services/*.js').pipe(ngFilesort()),
      gulp.src('./src/js/controllers/*.js').pipe(ngFilesort()),
      gulp.src(['src/templates/**/*.html']).pipe(templateCache({ module: 'Baocai' }))
    )
    .pipe(sourcemaps.init())
    .pipe(concat('app.js'))
    .pipe(ngAnnotate())
    .pipe(uglify())
    .pipe(rename({suffix: '.min'}))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest(path.join(config.dest, 'js')));
});


/*===================================================================
=            Watch for source changes and rebuild/reload            =
===================================================================*/

gulp.task('watch', function () {
  if (typeof config.server === 'object') {
    gulp.watch([config.dest + '/**/*'], ['livereload']);  
  }
  gulp.watch(['./src/html/**/*'], ['html','deploy']);
  gulp.watch(['./src/less/**/*'], ['less','deploy']);
  gulp.watch(['./src/js/**/*', './src/templates/**/*', config.vendor.js], ['js','deploy']);
  gulp.watch(['./src/images/**/*'], ['images','deploy']);
});


/*===================================================
=            Starts a Weinre Server                 =
===================================================*/

gulp.task('weinre', function() {
  if (typeof config.weinre === 'object') {
    var weinre = require('./node_modules/weinre/lib/weinre');
    weinre.run(config.weinre);
  } else {
    throw new Error('Weinre is not configured');
  }
});


/*======================================
=            Build Sequence            =
======================================*/

gulp.task('build', function(done) {
  // disable it
  config.weinre = false;
  
  var tasks = ['html', 'fonts', 'images', 'less', 'js'];
  seq('clean', tasks, done);
});

gulp.task('build_q', function(done) {
  var tasks = ['html', 'fonts', 'images', 'less', 'js'];
  seq('clean', tasks, done);
});

/*=====================================
=            copy files            =
=====================================*/
gulp.task('publish_web', function () {
  return gulp.src(['www/**/*']).pipe(gulp.dest('../../public/'));
});

gulp.task('publish_index', function () {  
  var stream = gulp.src(config.dest + '/index.html')
  return stream.pipe(rename({extname: '.php'}))
          .pipe(gulp.dest(config.index));
});

/*======================================
=            Deploy Sequence            =
======================================*/

gulp.task('deploy', function(done) {
  var tasks = ['publish_index'];
  seq('publish_web', tasks, done);
});


/*====================================
=            Default Task            =
====================================*/

gulp.task('default', function(done){
  var tasks = [];

  if (typeof config.weinre === 'object') {
    tasks.push('weinre');
  }

  if (typeof config.server === 'object') {
    tasks.push('connect');
  }

  tasks.push('watch');
  tasks.push('deploy');
  
  seq('build_q', tasks, done);
});
