// ***********************************************************
// This example plugins/index.js can be used to load plugins
//
// You can change the location of this file or turn off loading
// the plugins file with the 'pluginsFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/plugins-guide
// ***********************************************************

// This function is called when a project is opened or re-opened (e.g. due to
// the project's config changing)

/**
 * @type {Cypress.PluginConfig}
 */
// eslint-disable-next-line no-unused-vars
// module.exports = (on, config) => {
  // `on` is used to hook into various events Cypress emits
  // `config` is the resolved Cypress config
// }

const htmlvalidate = require('cypress-html-validate/dist/plugin');

module.exports = (on, config) => {
  const htmlConfig  = {
    rules: {
      // a few frameworks use ul or div for pagination, and aria-role="navigation" will trigger it
      'prefer-native-element': 'off',
      // not needed in test environment
      'require-sri': 'off'
    }
  }
  htmlvalidate.install(on, htmlConfig);
  /*
  on('before:browser:launch', (browser = {}, launchOptions) => {
    // `args` is an array of all the arguments that will
    // be passed to browsers when it launches
    // console.log(launchOptions.args) // print all current args
    if (browser.family === 'chromium' && browser.name !== 'electron') {
      // fullscreen ad auto open devtools
      launchOptions.args.push('--start-fullscreen', '--auto-open-devtools-for-tabs')
    }
    // whatever you return here becomes the launchOptions
    return launchOptions
  })
  */

  return config;
}
