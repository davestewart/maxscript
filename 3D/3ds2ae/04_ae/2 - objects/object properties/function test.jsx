function editData(obj){
	alert([obj.name,obj.data])
	obj.data=5
	obj.name="Dave"
	return obj
	}

	
var data={name:"John",data:"Once upon a time"}

data=editData(data)

alert([data.name,data.data])


/*

function editData(obj){
	alert([obj.name,obj.data])
	obj.data=5
	obj.name="Dave"
	return obj
	}

var data=new Object()
data.name="John"
data.data="Once upon a time"

		
var data=new Object()
data.name="John"
data.data="Once upon a time"

data=editData(data)

alert([data.name,data.data])
*/
