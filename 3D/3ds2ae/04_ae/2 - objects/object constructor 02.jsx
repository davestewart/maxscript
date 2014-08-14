// functions
	Object.prototype.isClass=function(str){
		return this.constructor.name==str
		}
		function isArray(obj){
		//return (typeof obj=="object" && obj.unshift!=undefined)
		return obj.constructor.name=="Array"
		}

	function is(str){
		return obj.constructor.name==str
		}
//delete Object.prototype.is
//delete Object.__proto__.isClass
// constructors
	function KeyArray(t,v){
		this.t=t
		this.v=v
		return this
		}

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
				new KeyArray(
					[0,1,2,3,4,5],
					[
						[-198.84,-245.83,-210.03],
						[-198.84,-245.73,-209.44],
						[-198.84,-245.44,-207.72],
						[-198.84,-244.97,-204.91],
						[-198.84,-244.32,-201.06],
						[-198.83,-243.5,-196.21]
					]
						
					),
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
			for(prop in obj.transform){
				var val=obj.transform[prop]
				alert(prop)
				//alert(obj.transform[d])
				if(obj.transform[d].isClass("KeyArray")){
					var t=obj.transform[d].t
					var v=obj.transform[d].v
					layer[d].setValuesAtTimes(t,v)
					}
				else{
					var v=obj.transform[d]
					//layer[prop].setValue(v)
					}
				}
			}
		else errArr.push(obj.name)
		}

	
	
// missing objects
	if(errArr.length>0){
		alert("The following named objects from 3dsmax did not update correctly in After Effects because they could not be found:\n\n"+errArr.toString()+"\n\nRename them correctly in one (or both) of the applications and try again.")
		}
