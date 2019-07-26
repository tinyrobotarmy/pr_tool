// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.

import '../css/app.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faTrash,faEdit } from '@fortawesome/free-solid-svg-icons'
import Bus from './Utils/Bus';

library.add(faTrash,faEdit)
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import * as React from 'react'
import * as ReactDOM from 'react-dom'
import Root from './Root'
// This code starts up the React app when it runs in a browser. It sets up the routing
// configuration and injects the app into a DOM element.
ReactDOM.render(<Root />, document.getElementById('react-app'))

window.flash = (message, type="success") => Bus.emit('flash', ({message, type}));