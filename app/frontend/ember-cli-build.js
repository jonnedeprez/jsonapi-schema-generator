/* eslint-env node */
const EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {

  let env = EmberApp.env() || 'development';
  let isProductionLikeBuild = ['production', 'staging', 'sandbox'].indexOf(env) > -1;

  let fingerprintOptions = {
    enabled: true,
    extensions: ['js', 'css', 'png', 'jpg', 'gif'],
  };

  let config = {
    fingerprint: fingerprintOptions,

    // emberCLIDeploy: {
    //   shouldActivate: env !== 'development'
    // },
    minifyCSS: { enabled: isProductionLikeBuild },

    minifyJS: { enabled: isProductionLikeBuild },
    tests: process.env.EMBER_CLI_TEST_COMMAND || !isProductionLikeBuild,
    hinting: process.env.EMBER_CLI_TEST_COMMAND || !isProductionLikeBuild,

    sassOptions: {
      includePaths: ['bower_components/bootstrap/scss'],
      sourceMapEmbed: true
    },

    autoprefixer: {
      sourcemap: !isProductionLikeBuild,
      // copied from bootstrap / github:
      browsers: [
        'Chrome >= 35',
        'Firefox >= 38',
        'Edge >= 12',
        'Explorer >= 10',
        'iOS >= 8',
        'Safari >= 8',
        'Android 2.3',
        'Android >= 4',
        'Opera >= 12'
      ]
    }
  };

  if (EmberApp.env() === 'development') {
    config.babel = {
      // sourceMaps: 'inline',
      exclude: [
        'check-es2015-constants',
        'transform-es2015-arrow-functions',
        'transform-es2015-block-scoped-functions',
        'transform-es2015-block-scoping',
        'transform-es2015-classes',
        'transform-es2015-computed-properties',
        'transform-es2015-destructuring',
        'transform-es2015-duplicate-keys',
        'transform-es2015-for-of',
        'transform-es2015-function-name',
        'transform-es2015-literals',
        'transform-es2015-object-super',
        'transform-es2015-parameters',
        'transform-es2015-shorthand-properties',
        'transform-es2015-spread',
        'transform-es2015-sticky-regex',
        'transform-es2015-template-literals',
        'transform-es2015-typeof-symbol',
        'transform-es2015-unicode-regex',
        'transform-regenerator',
        'transform-exponentiation-operator',
        'transform-async-to-generator',
        'syntax-trailing-function-commas'
      ]
    }
  }


  let app = new EmberApp(defaults, config);

  app.import('bower_components/tether/dist/css/tether.css');
  app.import('bower_components/tether/dist/js/tether.js');
  app.import('bower_components/bootstrap/dist/js/bootstrap.js');

  return app.toTree();
};
