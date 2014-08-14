// functions
	function isClass(obj,str){
		return obj.constructor.name==str
		}

	function isArray(obj){
		//return (typeof obj=="object" && obj.unshift!=undefined)
		return obj.constructor.name=="Array"
		}

	function getItemByName(str){
		var obj=app.project.items
		for(i=1;i<=obj.length;i++){
			if(obj[i].name==str)return obj[i]
			}
		return null
		}

	function rnd(n){
		return Math.floor(Math.random()*Math.pow(10,n))
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
			case "Solid":
				layer=comp.layers.addSolid(obj.color, obj.name, obj.width, obj.height, 1)
				layer.threeDLayer=true
				layer.acceptsLights.setValue(0)
				break;
			case "Null":
				layer=comp.layers.addNull()
				layer.threeDLayer=true
				layer.name=obj.name
				break;
			case "Camera":
				layer=comp.layers.addCamera(obj.name, [0,0])
				break;
			case "Light":
				layer=comp.layers.addLight(obj.name, [0,0])
				break;
			case "Text":
				layer=comp.layers.addText(obj.text)
				break;
			}
		layer.startTime=0
		return layer
		}
		
// variables
	var objArr=new Array()
	var errArr=new Array()
	var comp=app.project.activeItem
	var comp=getItemByName("Comp 1")

// objects



var obj= new Object()
	obj.properties={name:'X', parent:'undefined', aeClass:'Text', text:'X.'}
	obj.position=new KeyArray([0.0],[[-50,0,0]])
	obj.orientation=new KeyArray([0.0],[[0,89.99,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Z', parent:'undefined', aeClass:'Text', text:'Z.'}
	obj.position=new KeyArray([0.0],[[0,-50,0]])
	obj.orientation=new KeyArray([0.0],[[-90,0,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Y', parent:'undefined', aeClass:'Text', text:'Y.'}
	obj.position=new KeyArray([0.0],[[0,0,-50]])
	obj.orientation=new KeyArray([0.0],[[0,0,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Camera01', parent:'undefined', aeClass:'Camera', target:true}
	obj.position=new KeyArray([0.0,0.04,0.08,0.12,0.16,0.2,0.24,0.28,0.32,0.36,0.4,0.44,0.48,0.52,0.56,0.6,0.64,0.68,0.72,0.76,0.8,0.84,0.88,0.92,0.96,1.0,1.04,1.08,1.12,1.16,1.2,1.24,1.28,1.32,1.36,1.4,1.44,1.48,1.52,1.56,1.6,1.64,1.68,1.72,1.76,1.8,1.84,1.88,1.92,1.96,2.0,2.04,2.08,2.12,2.16,2.2,2.24,2.28,2.32,2.36,2.4,2.44,2.48,2.52,2.56,2.6,2.64,2.68,2.72,2.76,2.8,2.84,2.88,2.92,2.96,3.0,3.04,3.08,3.12,3.16,3.2,3.24,3.28,3.32,3.36,3.4,3.44,3.48,3.52,3.56,3.6,3.64,3.68,3.72,3.76,3.8,3.84,3.88,3.92,3.96,4.0],[[-377.59,-255.57,-446.28],[-376.3,-256.02,-445.55],[-372.55,-257.34,-443.41],[-366.49,-259.46,-439.97],[-358.29,-262.31,-435.32],[-348.1,-265.84,-429.55],[-336.09,-269.97,-422.77],[-322.42,-274.65,-415.08],[-307.24,-279.81,-406.55],[-290.72,-285.38,-397.31],[-273.02,-291.31,-387.43],[-254.3,-297.52,-377.02],[-234.72,-303.96,-366.18],[-214.44,-310.56,-355],[-193.62,-317.26,-343.58],[-172.42,-323.98,-332.01],[-151,-330.68,-320.39],[-129.53,-337.28,-308.82],[-108.16,-343.72,-297.4],[-87.05,-349.93,-286.22],[-66.36,-355.86,-275.38],[-46.26,-361.43,-264.97],[-26.91,-366.59,-255.09],[-8.46,-371.27,-245.85],[8.92,-375.4,-237.33],[25.08,-378.93,-229.63],[39.85,-381.78,-222.85],[53.07,-383.9,-217.08],[65.26,-385.22,-212.43],[77.02,-385.67,-208.99],[88.31,-381.29,-206.85],[99.1,-368.79,-206.12],[109.37,-349.12,-206.79],[119.07,-323.24,-208.74],[128.18,-292.1,-211.83],[136.67,-256.66,-215.97],[144.5,-217.88,-221.03],[151.64,-176.71,-226.9],[158.06,-134.1,-233.46],[163.73,-91.02,-240.6],[168.61,-48.42,-248.2],[172.68,-7.25,-256.15],[175.9,31.54,-264.33],[178.24,66.97,-272.62],[179.67,98.11,-280.92],[180.15,123.99,-289.09],[179.86,143.66,-297.04],[179.01,156.17,-304.64],[177.62,160.55,-311.78],[175.71,158.16,-318.34],[173.32,151.27,-324.21],[170.45,140.29,-329.27],[167.15,125.63,-333.41],[163.43,107.7,-336.51],[159.31,86.9,-338.45],[154.83,63.64,-339.13],[150,38.34,-330.89],[144.85,11.41,-307.61],[139.41,-16.76,-271.44],[133.69,-45.74,-224.52],[127.72,-75.13,-169.01],[121.53,-104.52,-107.05],[115.15,-133.51,-40.79],[108.58,-161.67,27.61],[101.87,-188.61,96.02],[95.03,-213.91,162.28],[88.09,-237.16,224.24],[81.07,-257.96,279.75],[73.99,-275.89,326.67],[66.89,-290.56,362.84],[59.78,-301.54,386.12],[52.69,-308.42,394.36],[45.64,-310.81,393.1],[38.66,-310,389.43],[31.78,-307.65,383.55],[25,-303.87,375.62],[18.37,-298.79,365.82],[11.91,-292.53,354.32],[5.63,-285.2,341.32],[-0.44,-276.92,326.99],[-6.26,-267.81,311.49],[-12.33,-257.98,295.02],[-19.06,-247.57,277.75],[-26.34,-236.68,259.85],[-34.08,-225.43,241.51],[-42.16,-213.95,222.91],[-50.48,-202.35,204.21],[-58.94,-190.75,185.6],[-67.43,-179.27,167.26],[-75.85,-168.02,149.37],[-84.08,-157.13,132.1],[-92.03,-146.72,115.62],[-99.59,-136.9,100.13],[-106.65,-127.79,85.79],[-113.12,-119.51,72.79],[-118.88,-112.17,61.3],[-123.82,-105.91,51.5],[-127.85,-100.83,43.57],[-130.86,-97.05,37.68],[-132.74,-94.7,34.02],[-133.4,-93.89,32.76]])
	obj.orientation=new KeyArray([0.0],[[0,0,0]])
	obj.scale=new KeyArray([0.0],[[99.99,99.99,99.99]])
	obj.pointOfInterest=new KeyArray([0.0],[[-30.32,-6.1,-14.89]])
obj.Zoom=new KeyArray([0],[724.26])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Point01', parent:'undefined', aeClass:'Null', width:50, height:50}
	obj.position=new KeyArray([0.0],[[0,0,0]])
	obj.orientation=new KeyArray([0.0],[[90,0,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane01', parent:'undefined', aeClass:'Solid', width:100, height:100, color:[1,0.0392157,0.0392157]}
	obj.position=new KeyArray([0.0],[[-54.95,0,0]])
	obj.orientation=new KeyArray([0.0],[[0,89.99,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane02', parent:'undefined', aeClass:'Solid', width:100, height:100, color:[0.176471,0.811765,0.027451]}
	obj.position=new KeyArray([0.0],[[0,0,54.94]])
	obj.orientation=new KeyArray([0.0],[[-180,0,-180]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane03', parent:'undefined', aeClass:'Solid', width:100, height:100, color:[1,0.0392157,0.0392157]}
	obj.position=new KeyArray([0.0],[[54.94,0,0]])
	obj.orientation=new KeyArray([0.0],[[0,-90,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane04', parent:'undefined', aeClass:'Solid', width:100, height:100, color:[0.176471,0.811765,0.027451]}
	obj.position=new KeyArray([0.0],[[0,0,-54.95]])
	obj.orientation=new KeyArray([0.0],[[0,0,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane05', parent:'undefined', aeClass:'Solid', width:100, height:100, color:[0,0.0470588,1]}
	obj.position=new KeyArray([0.0],[[0,54.95,0]])
	obj.orientation=new KeyArray([0.0],[[90,0,0]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane06', parent:'undefined', aeClass:'Solid', width:100, height:100, color:[0,0.0470588,1]}
	obj.position=new KeyArray([0.0],[[0,-54.94,0]])
	obj.orientation=new KeyArray([0.0],[[-90,0,-180]])
	obj.scale=new KeyArray([0.0],[[100,100,100]])
objArr.push(obj)




app.beginUndoGroup('3dsmax import')
// main loop
	for (obj in objArr){
		var obj=objArr[obj]
		var layer=comp.layers.byName(obj.properties.name)

		if(!layer)layer=addAEObject(obj.properties)
		
		if(layer){
			writeLn("Adding "+obj.properties.name+" ...")
			for(prop in obj){
				var val=obj[prop]
				//alert(prop + " : " + String(obj[prop]))
				//alert(prop=="orientation")
				//alert(obj.transform[d])
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
		}

	
	
// missing objects
	if(errArr.length>0){
		alert("The following named objects from 3dsmax did not update correctly in After Effects because they could not be found:\n\n"+errArr.toString()+"\n\nRename them correctly in one (or both) of the applications and try again.")
		}
//alert(objArr.length)
clearOutput()
app.endUndoGroup()

if(app.project.activeItem!=comp)alert(comp.name+" has been updated.")