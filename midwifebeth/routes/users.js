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
        renderUsers(res);
    });
    router.post('/', authentication, (req, res) => {
		let user = req.body;
		user.date = Date.now();
        db.findOne('users', { $or: [ {username: user.username}, {email: user.email} ]} ).then( ( result ) => {
            if( result ) {
                res.render('new-user', {error: 'a user with that name or email already registered'});
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
            date: Date.now()
        };
        if ( req.body.password ) {
            user.password = bcrypt.hashSync( req.body.password, 10);
        }
        if ( req.body.email ) {
            user.email = req.body.email;    
        }
        db.updateOne('users', {_id:_id}, {$set:user}).then( (result) => {
            renderUser(_id,res);
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