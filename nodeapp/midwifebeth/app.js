/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
try {
    const env 	= process.env;
    const config 	= require('./config.js');
    //
    // connect to database
    //
    const db = require('./db.js');
    db.connect(
        config.mongo.host,
        config.mongo.port,
        config.mongo.database,
        config.mongo.username,
        config.mongo.password
    ).then( () => {
        try {
            //
            // configure express
            //
            console.log('initialising express');
            let express = require('express');
            let bodyParser = require('body-parser');
            let mailer = require('./mailer.js')(config.mailer);
            //
            //
            //		
            let app = express();
            //
            //
            //
            app.use(bodyParser.json( {limit:'10mb'} ));
            app.use(bodyParser.urlencoded({'limit': '10mb', 'extended': true }));
            //
            // configure express
            //
            app.set('view engine', 'pug');
            app.use(express.static(__dirname+'/static',{dotfiles:'allow'}));
            //
            // session handling
            // TODO: session persistance https://www.npmjs.com/package/connect-mongo
            //
            app.use(require('cookie-parser')('unusual*windy'));
            app.use(require('express-session')({ secret: 'unusual*windy', resave: false, saveUninitialized: false }));
            //
            // authentication
            //
            let passport = require('./passportauth')( app, db );
            let local = require('./routes/local')( passport.passport, config, db, mailer );
            app.use( '/local', local );
            //
            // express routes
            //
            console.log('general routes');
            app.get('/', function (req, res) {
                res.render('index',{authorised:req.user && req.isAuthenticated()});
            });
            app.get('/homepage', function (req, res) {
                res.render('homepage');
            });
            console.log('content routes');
            let users = require('./routes/users')( passport.isAuthenticated, db, mailer );
            app.use( '/users', users );
            let sections = require('./routes/sections')( passport.isAuthenticated, db );
            app.use( '/sections', sections );
            let pages = require('./routes/pages')( passport.isAuthenticated, db );
            app.use( '/pages', pages );
            let blocks = require('./routes/blocks')( passport.isAuthenticated, db );
            app.use( '/blocks', blocks );
             //
            // configure websockets
            //
            console.log('configuring websocket router');
            let wsr = require('./websocketrouter');
            //
            // connect fileuploader
            //
            let fileuploader = require('./fileuploader');
            fileuploader.setup(wsr);
            //
            // create server
            //
            console.log('creating server');
            let httpx = require('./httpx');
            let server = httpx.createServer(config.ssl, { http:app, ws:wsr });
            //
            // start listening
            //
            console.log('starting server');
            server.listen(config.server.port, config.server.host, () => {
                console.log('server listening on : ' + config.server.host + ':' + config.server.port );
            });
        } catch( error ) {
            console.log( 'unable to start server : ' + error );
        }
    }).catch( function( err ) {
        console.log( 'unable to connect to database : ' + err );
    });
} catch(error) {
	console.log( 'unable to start server : ' + error);
}