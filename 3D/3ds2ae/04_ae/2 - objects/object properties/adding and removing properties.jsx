// set the object
obj=app.project.item(1).layer(5)

// add and remove properties
function addEffect(effect,remove){
	obj.property("Effects").addProperty(effect)
	prop=obj.property("Effects").property(effect).property(1).value//.remove()
	if(remove)then obj.property("Effects").property(effect).remove()
	}
//addEffect("Box Blur",false)


// iterate through properties and methods
function showProps1(){
	obj=app.project.item(1).layer(1)
	propGroup=obj.Effects(1)
	str=""
	for(p in propGroup){
		str+="\n===="+p+"====\n"+String(propGroup[p])//+"\n-------------------\n"
		}
	alert(str)
	}
//showProps1()
	

function showProps2(){
	obj=app.project.item(1).layer(1)
	propGroup=obj.Effects(1)
	str=""
	for(i=1;i<=propGroup.numProperties;i++){
		str+=i+" : "+propGroup.property(i).name+" ("+propGroup.property(i).propertyType+ ")\n"
		}
	alert(str)
	}
//showProps2()




/*
*/
// apply animated values
function applyValues(obj){
	var times=new Array()
	var values=new Array()
	for(i=0;i<400;i++){
		times.push(i/25)
		values.push([i*10,Math.random()*200])
		}
	obj.setValuesAtTimes(times, values)
	}
//applyValues(obj.position)




// layer by name
app.project.item(1).layers.byName("Null").name


obj.position.setValuesAtTimes([5], [[0,0,0]])
