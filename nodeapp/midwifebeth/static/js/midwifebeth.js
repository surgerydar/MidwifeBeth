/*eslint-env browser, es6*/
const midwifebeth = (() => {
    let content = null;
    //
    //
    //
    const performAction = ( method, url, payload, silent ) => {
        let request = {
            method: method.toUpperCase()
        };
        if (payload) {
            request.headers = {
                "Content-type": "application/json; charset=UTF-8"
            };
            request.body = JSON.stringify(payload);
        }
        fetch( url, request ).then((response) => {
            if ( !silent ) {
                response.text().then((text) => {
                    content.innerHTML = text;
                });
            }
        }).catch((error) => {
            if ( !silent ) {
                content.innerHTML = '<h1>' + error + '</h1>';
            }
        });
    };
    //
    // async websocket upload
    //
    const upload = (files,target,progress) => {
        return new Promise( ( resolve, reject ) => {            
            //
            // create upload worker
            //
            let uploadWorker = new Worker('/js/upload.js');
            uploadWorker.addEventListener( 'message', (e) => {
                //console.log( 'upload worker : message : ' + JSON.stringify( evt.data ) );
                switch ( e.data.command ) {
                    case "uploadstart" :
                        if ( progress ) {
                            progress.style.visibility = 'visible';
                            progress.innerHTML = "<h1>0%</h1>";
                        }
                        break;
                    case "uploadprogress" :
                        if ( progress ) {
                            let percent = Math.round( 100. * e.data.progress );
                            if ( isNaN( percent ) ) {
                                console.log( 'invalid progress : ' + e.data.progress );
                            }
                            progress.innerHTML = "<h1>" + percent + "%</h1>";
                        }
                        break;
                    case "uploaddone" :
                        if ( progress ) {
                            progress.style.visibility = 'hidden';
                        }
                        uploadWorker = null;
                        resolve(e.data.destination);
                        break;
                }
            });
            uploadWorker.addEventListener( 'error',  (e) => { 
                console.log('upload worker : ERROR : line ', e.lineno, ' in ', e.filename, ': ', e.message); 
                progress.innerHTML = 'Error : ' + e.message;
                reject(e.message);

            });
            //
            // start upload
            //
            let message = {
                command: "upload",
                files: files
            };   
            uploadWorker.postMessage(message);
        });
    };  
    //
    //
    //
    
    //
    //
    //
	return {
		init: () => {
            //
            // find container
            //
            content = document.querySelector('#content');
            if ( !content ) return;
            //
            //
            //
            const hookItems = () => {
                //
                //
                //
                const hookAction = ( element ) => {
                    let method          = element.getAttribute('data-method');
                    let url             = element.getAttribute('data-url');
                    let confirmAction   = element.getAttribute('data-confirm');
                    if ( method && url ) {
                        element.addEventListener('click', (e) => {
                            e.preventDefault();
                            //
                            // check for payload
                            //
                            let payload = element.getAttribute('data-payload');
                            if ( payload ) {
                                try {
                                    payload = JSON.parse(payload);
                                } catch( error ) {
                                    console.error( 'malformed payload : ' + payload + ' : error : ' + error);
                                    payload = null;
                                }
                            }
                            //
                            //
                            //
                            if ( confirmAction ) {
                                if ( confirm('do you want to ' + method + ' this item?') ) {
                                    performAction(method,url,payload);    
                               }
                            } else {
                                performAction(method,url,payload);
                            }
                            return false;
                        });
                    }
                };
                //
                // hook header items
                //
                const header = content.querySelector('#listview-header');
                if ( header ) {
                    let headerbuttons = header.querySelectorAll('[id^="button"]');
                    headerbuttons.forEach((button) => {
                        hookAction(button);    
                    });
                    let search = header.querySelector('[id^="search"]');
                    if ( search ) {
                        let searchUrl = search.getAttribute('data-url');
                        if ( searchUrl ) {
                            search.addEventListener('keyup',(e) => {
                                e.preventDefault();
                                if (e.keyCode == 13) {
                                    let filterUrl = searchUrl;
                                    if ( search.value.length > 0 ) {
                                        filterUrl += '?filter=' + search.value;    
                                    }
                                    performAction('get',filterUrl );
                                }
                                return false;
                            });
                        }
                    }
                }
                //
                // hook listitems
                //
                const items = content.querySelectorAll('.listitem');
                items.forEach( ( item ) => {
                    //
                    //
                    //
                    hookAction(item);
                    //
                    //
                    //
                    const itemradiobuttons = item.querySelectorAll('input[type=radio]');
                    itemradiobuttons.forEach( (button) => {
                        hookAction(button);
                    });
                });
                //
                // hook list item images
                //
                const itemImages = content.querySelectorAll('.listitemimage');
                itemImages.forEach((itemImage) => {
                let selectUrl = itemImage.getAttribute('data-select');
                    if ( selectUrl ) {
                        let selectName = itemImage.getAttribute('data-name');
                        itemImage.addEventListener('click',function() {
                            window.open( selectUrl, selectName );
                        });
                    }
                });
                //
                // hook buttons
                //
                const buttons = content.querySelectorAll('[id^="button"]'); 
                buttons.forEach( function(button) {
                    hookAction(button);
                });
                //
                // hook forms
                //
                const forms = content.querySelectorAll('form');
                forms.forEach( ( form ) => {
                    //
                    // intercept submit
                    //
                    form.addEventListener('submit', (e) => {
                        e.preventDefault();
                        //
                        //
                        //
                        let method = form.getAttribute('method');
                        let url = form.getAttribute('action');
                        if ( method && url ) {
                            //
                            // extract JSON from form data
                            //
                            let formData = new FormData(form);
                            let data = {};
                            formData.forEach( (value,key) => {
                                data[key] = value;    
                            });
                            //
                            //
                            //
                            performAction(method,url,data);
                         }
                         //
                         //
                         //
                         return false;
                    });
                    //
                    // hook form files
                    //
                    let formfiles = form.querySelectorAll('input[type="file"]'); 
                    formfiles.forEach( function(file) {
                        let targetId = file.getAttribute('data-target');
                        if ( targetId ) {
                            let target = form.querySelector(targetId);
                            if ( target ) {
                                file.addEventListener('change', (e) => {
                                    e.preventDefault();
                                    upload(file.files,target,form.querySelector('#progress')).then( (destination) => {
                                        target.src = destination;
                                        let method = target.getAttribute('data-method');
                                        let url = target.getAttribute('data-url');
                                        if ( method && url ) {
                                            performAction(method,url,{ content: destination });
                                        }
                                    }).catch( (error) => {
                                        alert( error );
                                    });
                                    return true;
                                }); 
                            }
                        }
                    });
                });
                //
                // hook resource link
                //
                const linkButton = content.querySelector('#link-button');
                if ( linkButton ) {
                    let link = linkButton.getAttribute('data-link');
                    if ( link ) {
                        linkButton.addEventListener('click', () => {
                            let textArea = document.createElement("textarea");
                            textArea.value = link;
                            document.body.appendChild(textArea);
                            textArea.select();
                            document.execCommand("Copy");
                            textArea.remove();  
                            alert( link + '\ncopied to clipboard')
                        });
                    }
                }
                //
                // execute any scripts
                // TODO: security risk, should validate all scripts
                //
                const scripts = content.querySelectorAll('script');
                scripts.forEach( function(script) {
                    try {
                        eval(script.text);  
                    } catch( error ) {
                        console.log( 'error evaluating script : ' + error + ' : ' + script.text );
                    }
                });
            };
            //
            // respond to content changes
            //
            const observer = new MutationObserver(hookItems); 
            observer.observe(content, { childList: true } );
            //
            // hook default ui
            //
            hookItems();
        }
    };
})();