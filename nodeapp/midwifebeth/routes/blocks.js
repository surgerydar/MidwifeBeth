/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
const express 	= require('express')
const router 	= express.Router()
const fs        = require('fs');

module.exports = function( authentication, db ) {
    //
    // common functions
    //
    let renderBlocks = (res) => {
		db.find('blocks',{}).then((blocks) => {
            let data = blocks.map( ( block ) => {
                return {
                    _id : block._id,
                    name: block.title + ' : ' + block.content,
                    url: '/blocks/' + block._id
                };
            });
			let param = {
                title: 'Blocks',
				backUrl: '/homepage',
				baseUrl: '/blocks',
				data: data
			};
			res.render('listview',param);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    };
    let renderBlock = ( _id, res ) => {
        db.findOne('blocks', {_id:_id}).then( (block) => {
            let param = {
                backUrl: '/pages/' + block.page_id,
                data: block
            };
            res.render('block', param);
        }).catch((error) => {
			res.render('error', {message:error});
		});
    };
    //
    // routes
    //
    console.log( 'setting blocks routes' );
    router.get('/', (req, res) => {
        if ( req.query.format === 'json' ) { 
            db.find('blocks',{}).then((blocks) => {
                /*
                res.json({
                    status: 'OK',
                    data: blocks
                });
                */
                res.json(blocks);
            }).catch( (error) => {
                /*
                res.json({
                    status: 'ERROR',
                    error: error
                });
                */
                res.json([]);
            });
        } else {
            if( req.user && req.isAuthenticated() ) {
                renderBlocks(res);
            } else {
                res.status(401).render('error',{message:'You have to be logged in to access this resource'});
            }
        }
    });
    router.post('/', authentication, (req, res) => {
		let block = req.body;
		block.date = Date.now();
		db.insert('blocks', block).then((result) => {
            console.log('post : /blocks/ : insertedId = ' + result.insertedId );
            renderBlock(result.insertedId,res);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
    //
    //
    //
    router.get('/:id', authentication, (req, res) => {
        renderBlock(db.ObjectId(req.params.id), res);
	});
	router.put('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
		let block = req.body;
		block.date = Date.now();
		db.updateOne('blocks', {_id:_id}, {$set:block}).then((result) => {
			renderBlock(_id,res);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
	router.delete('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
		db.removeOne('blocks', {_id:_id} ).then( (result) => {
            if ( result ) {
                if ( result.value.type === 'image' || result.value.type === 'video' ) {
                    // TODO: delete media
                    db.find('blocks',{content:result.value.content}).then((results) => {
                        if ( results.length === 0 ) {
                            let mediaPath = './static' + result.value.content;
                            fs.unlink( mediaPath, (err) => {
                                if ( err ) {
                                    console.error( 'error deleting : ' + mediaPath + ' : error : ' + err );
                                } else {
                                    console.log( 'deleted : ' + mediaPath);
                                }
                            });
                        } else {
                            console.log( 'found some blocks with media : ' + result.content + ' : ' + JSON.stringify(results) );
                        }
                    }).catch((error) => {
                        console.log( 'reserving content used elsewhere : ' + result.value.content);
                    });
                }
                res.redirect(303, '/pages/' + result.value.page_id );
            } else {
                res.render('error',{message:'sorry we encountered problems, please refresh your browser'});
            }
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
    //
    //
    //
    //
    return router;
}