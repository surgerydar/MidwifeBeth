/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
const express 	= require('express')
const router 	= express.Router()


module.exports = function( authentication, db ) {
    //
    // common functions
    //
    let renderPages = (res) => {
		db.find('pages',{}).then((pages) => {
            let data = pages.map( ( page ) => {
                return {
                    _id : page._id,
                    name: page.title,
                    url: '/pages/' + page._id
                };
            });
			let param = {
                title: 'Content',
				backUrl: '/homepage',
				baseUrl: '/pages',
                newEntry: {
                    title: '',
                    tags: ''
                },
				data: data
			};
			res.render('listview',param);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    };
    let renderPage = ( _id, res ) => {
		db.findOne('pages', {_id:_id}).then((page) => {
            db.find('blocks', {page_id:_id.toString()},{},{index:1}).then( (blocks) => {
                let param = {
                    backUrl: '/sections/' + page.section_id, // JONS: inconsistent but we always get to page via section 
                    addUrl: '/pages',
                    _id: _id,
                    title: page.title,
                    tags: page.tags,
                    blocks: blocks
                };
                res.render('page', param);
            });
		}).catch((error) => {
			res.render('error', {message:error});
		});
    };
    //
    // routes
    //
    console.log( 'setting pages routes' );
    router.get('/', (req, res) => {
        if ( req.query.format === 'json' ) {
            db.find('pages',{}).then((pages) => {
                /*
                res.json({
                    status: 'OK',
                    data: pages
                });
                */
                res.json(pages);
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
                renderPages(res);
            } else {
                res.status(401).render('error',{message:'You have to be logged in to access this resource'});
            }
        }  
    });
    router.post('/', authentication, (req, res) => {
		let page = req.body;
		page.date = Date.now();
		db.insert('pages', page).then((result) => {
            console.log('post : /pages/ : insertedId = ' + result.insertedId );
            renderPage(result.insertedId,res);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
    //
    //
    //
    router.get('/:id', authentication, (req, res) => {
        renderPage(db.ObjectId(req.params.id), res);
	});
	router.put('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
		let page = req.body;
		page.date = Date.now();
		db.updateOne('pages', {_id:_id}, {$set:page}).then((result) => {
			renderPage(_id,res);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
	router.delete('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
		db.removeOne('pages', {_id:_id}, {section_id:1}).then((result) => {
            // TODO: delete all blocks
            console.log( 'DELETE : /pages/' + req.params.id + ' : ' + JSON.stringify(result) );
            res.redirect(303,'/sections/' + result.value.section_id );
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