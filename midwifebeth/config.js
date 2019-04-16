/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */

let fs = require('fs');

function key() {
    try {
        return fs.readFileSync('/etc/letsencrypt/live/ravensbournetable.uk/privkey.pem');
    } catch( err ) {
        return fs.readFileSync('./ssl/server.key');
    }
}

function cert() {
    try {
        return fs.readFileSync('/etc/letsencrypt/live/ravensbournetable.uk/fullchain.pem');
    } catch( err ) {
        return fs.readFileSync('./ssl/server.crt');
    }
}

function ca() {
    try {
        return fs.readFileSync('/etc/letsencrypt/live/ravensbournetable.uk/chain.pem');
    } catch( err ) {
        return undefined;
    }
}

module.exports = {
	server: {
		host: "178.62.110.55",
		port: 8080
	},
	mongo: {
		host: "127.0.0.1",
		port: 27017,
		database: "midwifebeth"
	},
	ssl : {
		key: key(),
		cert: cert(),
		ca: ca(),
	}
};