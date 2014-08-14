/*
item=app.project.activeItem.layers[1]
alert(String(item.width))
*/
/*
function isArray(obj){
	return (typeof obj=="object" && obj.unshift!=undefined)
	}

obj=[1,2,3]
obj=new Object()
function test(){
	// commment!
	}
//obj.sort=test 

alert(isArray(obj))
alert(typeof obj.unshift)
//for(obj in Array.prototype)alert(Array.prototype[obj])

*/
is=undefined
/*
function is(str){
	return obj.constructor.name==str
	}
*/
Object.prototype.is=function(str){
	return this.constructor.name==str
	}

function Cunt(a,b){
	this.a=a
	this.b=b
	return this
	}

var obj=new Cunt(true,false)

//var obj=new Array()
//alert(obj.constructor.name=="Array")
str=""
for(c in obj)str+=String(obj[c])+"\n"
//alert(str)

var str="hello"

//alert(str.is("Cunt"))
//alert(str.constructor.name)

alert([1,2,3].is("Array"))

item=app.project.activeItem.layers[1].position.value
alert(item)
alert(item.is("Array"))
