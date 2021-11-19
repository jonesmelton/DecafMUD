// /**
//  * Create a new instance of the DecafMUD client.
//  * @name DecafMUD
//  * @class The DecafMUD Core
//  * @property {boolean} loaded This is true if DecafMUD has finished loading all
//  *     the external files it requires. We won't start executing anything until
//  *     this is true.
//  * @property {boolean} connecting This is true while DecafMUD is trying to
//  *     connect to a server and is still waiting for the socket to respond.
//  * @property {boolean} connected This is true if DecafMUD is connected to a
//  *     server. For internal use.
//  * @property {number} id The id of the DecafMUD instance.
//  * @param {Object} options Configuration settings for setting up DecafMUD.
//  */
//  var DecafMUD = function DecafMUD(options) {
// 	// Store the options for later.
// 	this.options = {};
// 	extend_obj(this.options, DecafMUD.options);

// 	if ( options !== undefined ) {
// 		if ( typeof options !== 'object' ) { throw "The DecafMUD options argument must be an object!"; }
// 		extend_obj(this.options, options);
// 	}

// 	// Store the settings for later.
// 	this.settings = {};
// 	extend_obj(this.settings, DecafMUD.settings);

// 	// Set up the objects that'd be shared.
// 	this.need = [];
// 	this.inbuf = [];
// 	this.telopt = {};

// 	// Increment DecafMUD.last_id and use that as this instance's ID.
// 	this.id = ( ++DecafMUD.last_id );

// 	// Store this instance for easy retrieval.
// 	DecafMUD.instances.push(this);

// 	// Start doing debug stuff.
// 	this.debugString('Created new instance.', 'info');

// 	// If we have console grouping, log the options.
// 	if ( 'console' in window && console.groupCollapsed ) {
// 		console.groupCollapsed('DecafMUD['+this.id+'] Provided Options');
// 		console.dir(this.options);
// 		console.groupEnd();
// 	}

// 	// Load those. After that, chain to the initSplash function.
// 	this.waitLoad(this.initSplash);

// 	return this;
// };

// the original is declared as an immediately invoked function taking `window` as its argument
//
// globals, required stuff, and state ?

// DEBUG_MODE = false;
// global?

// window
// the decafmud definition file attaches a bunch of stuff to window then returns it
// to be passed into the next I guess? chainable?

// defines a generic addEventListener in this context
// var addEvent = function(node, etype, func): void

// DecafMUD

// the original defined but didn't override these functions
// String.prototype.endsWith(s: string): boolean
// String.prototype.substr_count(needle: string): number

// it has "plugins"
// each is a function that takes a decaf a decafmud object (or window??)
// exports itself like this
// //  DecafMUD.plugins.Socket.websocket = DecafWebSocket;

// type DecafMudOptions = any & {};
// type AnsiString = string;

// export default class DecafMUD {
//   __options: DecafMudOptions;
//   sendToMud(line: string): void {}
//   listenToMud(event: AnsiString, listener: Function): void {}

//   constructor(options) {
//     this.__options = options;
//   }
// }
