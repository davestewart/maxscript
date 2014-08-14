function show(obj){
	str=""
	//for(i=1;i<obj.numProperties;i++)str+=i+" : "+String(obj.property(i).name)+"\n"
	for(prop in obj)str+=prop + " : "+String(obj[prop])
	alert(str)
	}
//show(app.project.activeItem.layers[1].Effects)
/*

str=app.project.activeItem.layers[1].Effects.property(1).name
alert(str)
*/

function show(obj,d){
	str=""
	for(i in obj){
		str+=i + " : " +String(obj[i])+"\n"
		}
	alert(str)
	}
//show(app.project.activeItem,false)
app.project.activeItem,false


function showIndexedProperties(obj){	
	// padding function
		function pad(d){
			var str=""
			for(var i=0;i<d;i++)str+="	"
			return str
			}
	// recursive function
		function walk(obj,d){
			if(obj != undefined || obj!= null){
				d+=1
				for(var i=1;i<=obj.numProperties;i++){
					// properties
						var prop=obj.property(i)
						var pName=prop.name
						if(prop.propertyValueType!=PropertyValueType.NO_VALUE){
							var pValue=String(prop.value)
							//pValue=prop.propertyType==PropertyType.PROPERTY
							}
						else{
							var pValue=''
							}
					// write
						str+=pad(d)
						str+=i+" : "+pName+" : "+pValue+"\n"
					// recurse
						walk(prop,d)
					}
				d-=1
				}
			}
	// run it!
		var str=typeof obj
		if(obj != undefined || obj!= null){
			var d=-1
			var str='Properties of: '+obj.name+'\n'
			str+='============================\n'
			walk(obj,d)
			}
		alert(str)
	}

function showProperties(obj,incFns){
	// padding function
		function pad(d){
			var str=""
			for(var i=0;i<d;i++)str+="	"
			return str
			}
	// recursive function
		function walk(obj,d,incFns){
			if(d>2)exit
			if(obj != undefined || obj!= null){
				d+=1
				for(i in obj){
					try{
					// properties
						var pName=i
						var pValue=obj[i]
					// function specific
						if(typeof pValue=='function'){
							pValue='-- function --'
							if(incFns!=true)continue
							}
					// write
						str+=pad(d)
						//str+=obj[i].numProperties+' '
						str+=pName +" : "+ String(pValue) +"\n"
						}
					catch(err){}
					// recurse
						if(obj.matchName!='ADBE AV Layer')walk(pValue,d,incFns)
					}
				d-=1
				}
			}
	// run it!
		var str=typeof obj
		if(obj != undefined || obj!= null){
			var d=-1
			var str='Properties of: '+obj.name+'\n'
			str+='============================\n'
				walk(obj,d)

			}
		alert(str)
		//if(str.saveToFile!=undefined)str.saveToFile()// 'c:\\temp.txt'
	}



//obj=app.project.items[4].mainSource
//obj=app.project.activeItem.layers[1].effect(1)
//obj=app.project.activeItem.layers[1]


//showProperties(obj,false)
//showIndexedProperties(obj,false)

//showProperties(obj)
/*
str=''
for(prop in obj)str+=String(prop)+' : '+String(obj[prop])+'\n'
alert(str)
*/