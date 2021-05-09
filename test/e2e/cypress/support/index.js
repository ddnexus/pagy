// ***********************************************************
// This example support/index.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************

// Import commands.js using ES2015 syntax:
import './commands'

// Alternatively you can use CommonJS syntax:
// require('./commands')


// Fix for cypress bug affecting cypress-snapshots-plugin
// https://github.com/meinaart/cypress-plugin-snapshots/issues/10#issuecomment-514459554
// it requires the following addition at the top of each file:
// import { fixCypressSpec } from '../support'
// beforeEach(fixCypressSpec(__filename))
export const fixCypressSpec = filename => () => {
  const path = require('path')
  // const relative = filename.substr(1) // removes leading "/"
  // we don't need to remove the leading "/"
  const relative = filename
  const projectRoot = Cypress.config('projectRoot')
  const absolute = path.join(projectRoot, relative)
  Cypress.spec = {
    absolute,
    name: path.basename(filename),
    relative
  }
}
