// functions
	function createFile(name,str){
		f=File(name)
		f.open('w','????','????')
		f.writeln(str)
		f.close()
		}


// code
	// set current folder
		root=Folder('/E/03_Scripting/3ds2ae/04_ae/1 - utility/filesystem stuff/')
		Folder.current=root
	
	// write new file
		for(i=0;i<10;i++){
			Folder(i.toString()).create()
			for(j=0;j<10;j++){
				str=Math.random()
				createFile(i+'/'+j+'.txt',str)
				}
			}

	
	/*


function createFolder(path,makeCurrent){
	
	// make a single relative path folder
		if(path.indexOf('/')==-1){
			Folder(path).create()
			}
	// make an absolute path folder
		else{
			
			}
	alert(Folder.current)
	
	/*
	var tmpPath=Folder.current
	if(path!=undefined)Folder.current=path
	result=Folder(path+'/'+name).create()
	if(!result)alert('Folder not created!')
	else return Folder(path+'/'+name)
	*/
	}
/*
*/
/*
Folder.current='test'
*/
//fld=createFolder('dave',true)
Folder('dave').create()
