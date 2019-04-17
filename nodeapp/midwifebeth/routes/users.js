/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
const express 	= require('express')
const router    = express.Router()
const bcrypt    = require('bcryptjs')


module.exports = ( authentication, db, mailer ) => {
    //
    // utility functions
    //
    const renderUsers = (res) => {
		db.find('users',{},{password:0}).then((users) => {
            let data = users.map( (user) => {
              console.log( '/users : mapping : ' + JSON.stringify( user ) );
              return {
                    _id: user._id,
                    name: user.username,
                    url: '/users/' + user._id
                };
            });
			let param = {
                title: 'Users',
				backUrl: '/homepage',
                baseUrl: '/users',
                newUrl: '/users/new',
                newMethod: 'get',
				data: data
			};
			res.render('listview',param);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    };
    const renderUser = ( _id, res ) => {
        db.findOne('users', {_id:_id}, {password:0}).then((user) => {
            if ( user ) {
                let param = {
                    backUrl: '/users',
                    user: user
                };
                res.render('user', param);
            } else {
                res.render('error', {message:'Unable to find user ' + _id });
            }
        }).catch((error) => {
            res.render('error', {message:error});
        });
    };
    //
    // routes
    //
    console.log( 'setting users routes' );
    router.get('/', authentication, (req, res) => {
        if ( req.query.format === 'json' ) {
            db.find('users',{},{password:0}).then((users) => {
                res.json({
                    status: 'OK',
                    data: users
                });
            }).catch( (error) => {
                res.json({
                    status: 'ERROR',
                    error: error
                });
            });
        } else {
            renderUsers(res);
        }
    });
    router.post('/', authentication, (req, res) => {
        let user = {
            username: req.body.username,
            email: req.body.email,
            password: bcrypt.hashSync( req.body.password, 10),
            date: Date.now()
        };
        db.findOne('users', { $or: [ {username: user.username}, {email: user.email} ]} ).then( ( result ) => {
            if( result ) {
                res.render('new-user', {error: 'a user has already registered that name or email'});
            } else {
                db.insert('users', user).then( () => {
                    renderUsers(res);
                });
            }
        }).catch( (error) => {
			res.render('error',{message:error});
        });
    });
    //
    //
    //
    router.get('/:id', authentication, (req, res) => {
        if ( req.params.id === 'new' ) {
            res.render('new-user');
        } else {
            renderUser(db.ObjectId(req.params.id), res);
        }
	});
	router.put('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
        let user = {
            username: req.body.username,
            email: req.body.email,
            date: Date.now()
        };
        //
        // optional password
        //
        if ( req.body.password ) {
            user.password = bcrypt.hashSync( req.body.password, 10);
        }
        db.findOne('users', { $and: [ { _id: { $ne: _id } }, { $or: [ {username: user.username}, {email: user.email} ] } ] } ).then( ( result ) => {
            if( result ) {
                let param = {
                    backUrl: '/users',
                    user: req.body,
                    error: 'a user has already registered that name or email'
                };
                res.render('user', param);
            } else {
                db.updateOne('users', {_id:_id}, {$set:user}).then( (result) => {
                    renderUser(_id,res);
                });
            }
        }).catch((error) => {
            res.render('error',{message:error});
        });
    });
	router.delete('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
		db.remove('users', {_id:_id}).then((result) => {
			renderUsers(res);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
    //
    //
    return router;
}