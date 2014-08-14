


// get file
	fName='textXXX.txt'
	f=File(fName)
// delete old file
	if(f.exists)if(confirm("Delete file?"))f.remove()

// write new file
	f.open('w','????','????')
	f.writeln(Math.random())
	f.close()
/*

	str=''
	for(prop in f.constructor)str+=prop+'\n'
	
	alert(f.constructor.name)
*/
//	if(confirm("Delete file?"))
/*
// get created
	alert(
		f.fsName.toString()+
		'\n'+
		f.created.toString()+
		'\n'+
		f.modified.toString()
		)
	
	f.copy('text.txt')
	alert(
		f.fsName.toString()+
		'\n'+
		f.created.toString()+
		'\n'+
		f.modified.toString()
		)
	
*/
