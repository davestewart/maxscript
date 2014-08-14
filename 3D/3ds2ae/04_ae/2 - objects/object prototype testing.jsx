

"None of this code is private..."

function isClass(obj,str){
	return obj.constructor.name==str
	}

Object.prototype.isClass=function (str){
	//return this.constructor.name==str
	function doIt(str){
		return true
		}
	}

Object.prototype.isClass=function(str){return this.constructor.name==str}
	
delete Object.prototype.isClassOf
	
arr=new Array(1,2,3,4)
str=""
for(a in arr)str+=(String(arr[a])+", ")
alert(str)
alert(arr.isClass('Array'))

//alert(isClass(arr,'Array'))


/*
Object.prototype.isClass=function(str){
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
*/