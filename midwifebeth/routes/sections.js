/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
const express 	= require('express')
const router 	= express.Router()


module.exports = function( authentication, db ) {
    //
    // common functions
    //
    let renderSections = (res) => {
		db.find('sections',{}).then((sections) => {
            let data = sections.map( ( section ) => {
                return {
                    _id : section._id,
                    name: section.title,
                    url: '/sections/' + section._id
                };
            });
			let param = {
                title: 'Content',
				backUrl: '/homepage',
				baseUrl: '/sections',
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
    let renderSection = ( _id, res ) => {
		db.findOne('sections', {_id:_id}).then((section) => {
            db.find('pages', {section_id:_id.toString()},{},{index:1}).then( (pages) => {
                let param = {
                    backUrl: '/sections',
                    addUrl: '/sections',
                    _id: _id,
                    title: section.title,
                    tags: section.tags,
                    pages: pages
                };
                res.render('section', param);
            });
		}).catch((error) => {
			res.render('error', {message:error});
		});
    };
    //
    // routes
    //
    console.log( 'setting sections routes' );
    router.get('/', authentication, (req, res) => {
        renderSections(res);
    });
    router.post('/', authentication, (req, res) => {
		let section = req.body;
		section.date = Date.now();
		db.insert('sections', section).then((result) => {
            console.log('post : /sections/ : insertedId = ' + result.insertedId );
            renderSection(result.insertedId,res);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
    //
    //
    //
    router.get('/:id', authentication, (req, res) => {
        renderSection(db.ObjectId(req.params.id), res);
	});
	router.put('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
		let section = req.body;
		section.date = Date.now();
		db.updateOne('sections', {_id:_id}, {$set:section}).then((result) => {
			renderSection(_id,res);
		}).catch((error) => {
			res.render('error',{message:error});
		});
    });
	router.delete('/:id', authentication, (req, res) => {
        let _id = db.ObjectId(req.params.id);
		db.remove('sections', {_id:_id}).then((result) => {
			renderSections(res);
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