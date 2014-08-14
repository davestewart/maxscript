// functions
	function createFile(name,str){
		f=File(name)
		f.open('w','????','????')
		f.writeln(str)
		f.close()
		}


// code
	function createTestFiles(){
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
		}

	function createFolder(str){
		var result=Folder(str).create()
		var fld=Folder(Folder.current.toString()+'/'+str)
		if(result){
			return fld
			}
		else{
			if(fld.exists){
				alert('Folder '+fld.toString()+' already exists!')
				return fld
				}
			else alert('Folder '+fld.toString()+' could not be created')
			}
		}

var fld=createFolder('dave')
alert(fld.getFiles())