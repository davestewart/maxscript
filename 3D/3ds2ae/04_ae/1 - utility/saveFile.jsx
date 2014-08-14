
// get file
	f=File('text.txt')
	alert(
		f.fsName.toString()+
		'\n'+
		f.created.toString()+
		'\n'+
		f.modified.toString()
		)
	
// read file
	f.open('r','????','????')
	str=f.read(f.length)
	f.close()	
	
	
// write new file
	f.open('w','????','????')
	f.writeln(str)
	f.writeln('def')
	f.close()	

	

