
function testTry(printErrors){
	try{
		unknownFunction(unknownVariable)
		throw 'whatever'
		}
	catch(err){
		str=''
		for(i in err)str+=i+': '+err[i]+'\n'
		if(printErrors)alert(str)
		}
	}

testTry(false)