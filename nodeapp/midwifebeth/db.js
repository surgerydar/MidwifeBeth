/* eslint-env node, mongodb, es6 */
/* eslint-disable no-console */
//
// database
//
const MongoClient 	= require('mongodb').MongoClient;
const ObjectId 		= require('mongodb').ObjectID;


function Db() {
}

Db.prototype.connect = function( host, port, database, username, password ) {
	host 		= host || '127.0.0.1';
	port 		= port || 27017;
	database 	= database;
	var authentication = username && password ? username + ':' + password + '@' : '';
	var url = host + ':' + port + '/' + database;
	console.log( 'connecting to mongodb://' + authentication + url );
	var self = this;
	return new Promise( ( resolve, reject ) => {
		try {
			MongoClient.connect('mongodb://'+ authentication + url, (err,db) => {
				if ( !err ) {
					console.log("Connected to database server");
					self.db = db;
					resolve( db );
				} else {
					console.log("Unable to connect to database : " + err);
					reject( err );
				}
			});
		} catch( err ) {
			reject( err );
		}
	});
}
//
// generic function
//
Db.prototype.drop = function( collection ) {
	var db = this.db;
	return new Promise( ( resolve, reject ) => {
		try {
			db.collection( collection ).drop( (err,result) => {
				if ( err ) {
                	console.log( 'drop : ' + collection + ' : error : ' + err );
					reject( err );
				} else {
					resolve( result );
				}
			});
		} catch( err ) {
            console.log( 'drop : ' + collection + ' : error : ' + err );
			reject( err );
		}
	});
}

Db.prototype.count = function( collection, query ) {
	var db = this.db;
	return new Promise( ( resolve, reject ) => {
		try {
			db.collection( collection ).count(query, (err,result) => {
				if ( err ) {
                    console.log( 'count : ' + collection + ' : error : ' + err );
					reject( err );
				} else {
					resolve( result );
				}
			});
		} catch( err ) {
            console.log( 'drop : ' + collection + ' : error : ' + err );
			reject( err );
		}
	});
}

Db.prototype.insert = function( collection, document ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
        try {
            db.collection( collection ).insertOne( document, (err,result) => {
               if ( err ) {
                   console.log( 'insert : ' + collection + ' : error : ' + err );
                   reject( err );
               } else {
                   resolve( result );
               }
            });
        } catch( err ) {
            console.log( 'insert : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.insertMany = function( collection, documents ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
        try {
            db.collection( collection ).insertMany( documents, (err,result) => {
               if ( err ) {
                   console.log( 'insertMany : ' + collection + ' : error : ' + err );
                   reject( err );
               } else {
                   resolve( result );
               }
            });
        } catch( err ) {
            console.log( 'insert : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.remove = function( collection, query ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
        try {
            db.collection( collection ).remove( query, (err,result) => {
               if ( err ) {
                   console.log( 'remove : ' + collection + ' : error : ' + err );
                   reject( err );
               } else {
                   resolve( result );
               }
            });
        } catch( err ) {
            console.log( 'remove : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.removeOne = function( collection, query, projection ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
        try {
            let options = {};
            if ( projection ) {
                options.projection = projection; 
            }
            db.collection( collection ).findOneAndDelete( query, options, (err,result) => {
               if ( err ) {
                   console.log( 'remove : ' + collection + ' : error : ' + err );
                   reject( err );
               } else {
                   resolve( result );
               }
            });
        } catch( err ) {
            console.log( 'remove : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.updateOne = function( collection, query, update ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
         try {
             db.collection( collection ).findOneAndUpdate( query, update, (err,result) => {
                if ( err ) {
                    console.log( 'update : ' + collection + ' : error : ' + err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( 'update : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.updateMany = function( collection, query, update ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
         try {
             db.collection( collection ).updateMany( query, update, (err,result) => {
                if ( err ) {
                    console.log( 'update : ' + collection + ' : error : ' + err );
                    reject( err );
                } else {
                    resolve( result );
                }
             });
        } catch( err ) {
            console.log( 'update : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.find = function( collection, query, projection, order, offset, limit ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
        try {
            db.collection( collection ).find(query||{},projection||{}).sort(order||{}).skip(offset||0).limit(limit||0).toArray( (err,result) => {
                if ( err ) {
                    console.log( 'find : ' + collection + ' : error : ' + err );
                    reject( err );
                } else {
                    resolve( result );
                }
            });  
        } catch( err ) {
            console.log( 'find : ' + collection + ' : error : ' + err );
            reject( err );
        }
    });
}

Db.prototype.findOne = function( collection, query, projection ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
        try {
            db.collection(collection).findOne(query,projection||{}, (err,result) => {
                if ( err ) {
                    console.log( 'findOne : ' + collection + ' : error : ' + err );
                    reject( err );
                } else {
                    resolve( result );
                }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.findAndModify = function( collection, query, sort, update, options ) {
    var db = this.db;
    return new Promise( ( resolve, reject ) => {
        try {
            db.collection(collection).findAndModify( query, sort, update, options, (err,result ) => {
                if ( err ) {
                    console.log( 'findAndModify : ' + collection + ' : error : ' + err );  
                    reject( err );
                } else {
                    resolve( result );
                }
            });
        } catch( err ) {
            console.log( err );
            reject( err );
        }
    });
}

Db.prototype.ObjectId = function( hex ) {
    return new ObjectId.createFromHexString(hex);
}

module.exports = new Db();

