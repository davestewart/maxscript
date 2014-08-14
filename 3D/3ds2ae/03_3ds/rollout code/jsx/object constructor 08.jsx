// delete file on loading
	try{
		File('maxObjects.jsx').remove()
		}
	catch(err){
		}


// functions
	function isClass(obj,str){
		return obj.constructor.name==str
		}

	function isArray(obj){
		//return (typeof obj=='object' && obj.unshift!=undefined)
		return obj.constructor.name=='Array'
		}

	function getItemByName(str){
		var obj=app.project.items
		for(i=1;i<=obj.length;i++){
			if(obj[i].name==str)return obj[i]
			}
		return null
		}

// constructors
	function KeyArray(t,v){
		this.t=t
		this.v=v
		return this
		}

// new objects
	function addAEObject(obj){
		var layer
		switch(obj.aeClass){
			case 'Solid':
				layer=comp.layers.addSolid(obj.color, obj.name, obj.width, obj.height, 1)
				layer.threeDLayer=true
				layer.acceptsLights.setValue(0)
				break;
			case 'Null':
				layer=comp.layers.addNull()
				layer.threeDLayer=true
				layer.name=obj.name
				break;
			case 'Camera':
				layer=comp.layers.addCamera(obj.name, [0,0])
				break;
			case 'Light':
				layer=comp.layers.addLight(obj.name, [0,0])
				break;
			case 'Text':
				layer=comp.layers.addText(obj.text)
				break;
			}
		layer.startTime=0
		return layer
		}
		
// variables
	var objArr=new Array()
	var errArr=new Array()

// comp
	var comp
	comp=getItemByName('%')
	if(comp==undefined){
		//comp=app.project.activeItem
		}

// update comp ? ----------------------------------------------------------------------

%

// objects----------------------------------------------------------------------

%


// population code
	if(comp!=undefined){
		app.beginUndoGroup('3dsmax import')

	// main loop
		for (obj in objArr){
			var obj=objArr[obj]
			var layer=comp.layers.byName(obj.properties.name)
	
			if(!layer)layer=addAEObject(obj.properties)
			
			if(layer){
				writeLn('Adding '+obj.properties.name+' ...')
				for(prop in obj){
					var val=obj[prop]
					try{
						if(obj[prop].v.length>1){
							var t=obj[prop].t
							var v=obj[prop].v
							layer[prop].setValuesAtTimes(t,v)
							if(prop=='orientation'){
								layer['orientation'].setValuesAtTimes(t,v)
								}
							}
						else{
							var v=obj[prop].v[0]
							layer[prop].setValue(v)
							}
						}
					catch(err){
						}
					}
				}
			else errArr.push(obj.name)
			}	// end main loop
	
		clearOutput()
		app.endUndoGroup()
		}
	else{
	// missing comp warning
		alert('The target comp couldn\'t be found. Re-import the comp list into 3dsmax and try again.')
		}
// done
	if(app.project.activeItem!=comp)alert(comp.name+' has been updated.')

