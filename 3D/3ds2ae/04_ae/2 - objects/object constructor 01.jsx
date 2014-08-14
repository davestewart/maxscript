// constructors
	function Solid(
		name,w,h,
		pos,rot,sca,opa
		){
			this.name=name
			this.width=w
			this.height=h
	
			this.transform=new Object()
			this.transform.position=pos
			this.transform.rotation=rot
			this.transform.scale=sca
			this.transform.opacity=opa
/*
			this.property=new Object()
			this.property.FielfOfView=fov
			this.effects=new Object()
			this.material=new Object()
*/
			return this
			}

// variables
	objArr=new Array()
	errArr=new Array()

// declarations	
	var obj= new Solid(
				"White Solid 1", 30, 100,
				[100,100],
				45,
				[100,100,100],
				100
				)
	objArr.push(obj)


// main loop
	for (obj in objArr){
		var obj=objArr[obj]
		var layer=app.project.activeItem.layers.byName(obj.name)
		if(layer){
			for(d in obj.transform){
				//alert(obj.transform[d])
				layer[d].setValue(obj.transform[d])
				}
			}
		else errArr.push(obj.name)
		}

	
	
// missing objects
	if(errArr.length>0){
		alert("The following named objects from 3dsmax did not update correctly in After Effects because they could not be found:\n\n"+errArr.toString()+"\n\nRename them correctly in one (or both) of the applications and try again.")
		}
