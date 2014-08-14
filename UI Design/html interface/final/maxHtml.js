function maxLink(href,text,idStr,classStr){
	if(text == undefined)text = href
	href = "javascript:maxCmd('" +href+ "')"
	addLink(href,text,idStr,classStr)
	}

function addLink(href,text,idStr,classStr){

	// text
		if(text == undefined)text = href

	// tag to add link to
		var tag = document.getElementById(idStr)

		if(idStr == "" || tag == undefined){
			tag = document.body
			}

	// create DOM objects
		var lnk = document.createElement('a');
		var txt = document.createTextNode(text);
		var brk = document.createElement('br');

	// add attributes
		lnk.setAttribute('href', href);
		if(classStr != undefined)lnk.setAttribute('class', classStr);

	// do the DOM add	
		newLink = tag.appendChild(lnk); 
		newText = newLink.appendChild(txt); 
		newLink.appendChild(brk)
	}

function maxCmd(str){
	try{
		// url calls
			str = str.split("'").join("\\'")
			url	= "javascript:'maxscript:" +str+ "';void(0)"
			window.navigate(url)
		// debug
			if(document.getElementById('debug')!=undefined){
				document.getElementById('tfJavaScript').innerText = str
				document.getElementById('tfUrl').innerText = url
				}
		}
	catch(err){
		alert('There was a problem with the string sent to match; possibly escaped quotes?')
		}
	}
