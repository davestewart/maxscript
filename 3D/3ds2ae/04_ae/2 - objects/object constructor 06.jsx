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
/*
	var obj= new Object()
		obj.properties={name:'New Solid '+rnd(3),aeClass:'Solid',width:30,height:100,color:[Math.random(),Math.random(),Math.random()]}
		obj.position=new KeyArray([0.0,0.2,0.4,0.6,0.8,1.0,1.2,1.4,1.6,1.8,2.0,2.2,2.4,2.6,2.8,3.0,3.2,3.4,3.6,3.8,4.0],[[100,0,0],[99.89,0,4.52],[98.47,0,17.39],[92.89,0,37.02],[79.64,0,60.47],[56.04,0,82.81],[21.97,0,97.55],[-18.84,0,98.2],[-58.83,0,80.86],[-88.54,0,46.49],[-99.99,0,1.56],[-89.94,0,-43.74],[-61.23,0,-79.07],[-21.64,0,-97.64],[19.39,0,-98.11],[54.07,0,-84.12],[78.4,0,-62.07],[92.28,0,-38.52],[98.27,0,-18.52],[99.86,0,-5.14],[100,0,0]])
	objArr.push(obj)
		
	var obj= new Object()
		obj.properties={name:'Camera 3',aeClass:'Camera'}
		obj.position=new KeyArray([0.0,0.4,0.8,1.2,1.6,2.0,2.4,2.8,3.2,3.6,4.0],[[-198.84,210.03,-245.83],[-198.78,158.71,-237.18],[-198.56,36.32,-216.55],[-198.09,-109.75,-191.92],[-197.32,-232.13,-171.29],[-196.16,-283.45,-162.63],[-156.94,-236.48,-170.2],[-65.4,-124.46,-188.25],[43.41,9.23,-209.79],[134.41,121.25,-227.84],[172.54,168.22,-235.41]])
		obj.pointOfInterest=new KeyArray([0.0,0.04,0.08,0.12,0.16,0.2,0.24,0.28,0.32,0.36,0.4,0.44,0.48,0.52,0.56,0.6,0.64,0.68,0.72,0.76,0.8,0.84,0.88,0.92,0.96,1.0,1.04,1.08,1.12,1.16,1.2,1.24,1.28,1.32,1.36,1.4,1.44,1.48,1.52,1.56,1.6,1.64,1.68,1.72,1.76,1.8,1.84,1.88,1.92,1.96,2.0,2.04,2.08,2.12,2.16,2.2,2.24,2.28,2.32,2.36,2.4,2.44,2.48,2.52,2.56,2.6,2.64,2.68,2.72,2.76,2.8,2.84,2.88,2.92,2.96,3.0,3.04,3.08,3.12,3.16,3.2,3.24,3.28,3.32,3.36,3.4,3.44,3.48,3.52,3.56,3.6,3.64,3.68,3.72,3.76,3.8,3.84,3.88,3.92,3.96,4.0],[[-19.66,-1.84,-2.09],[-19.64,-1.84,-2.08],[-19.61,-1.83,-2.04],[-19.55,-1.83,-1.97],[-19.46,-1.82,-1.87],[-19.36,-1.81,-1.75],[-19.23,-1.8,-1.61],[-19.09,-1.78,-1.45],[-18.93,-1.77,-1.26],[-18.74,-1.75,-1.06],[-18.55,-1.73,-0.83],[-18.34,-1.71,-0.59],[-18.11,-1.69,-0.33],[-17.87,-1.67,-0.06],[-17.62,-1.64,0.23],[-17.35,-1.62,0.53],[-17.08,-1.59,0.84],[-16.8,-1.56,1.16],[-16.5,-1.54,1.49],[-16.21,-1.51,1.83],[-15.9,-1.48,2.18],[-15.59,-1.45,2.53],[-15.28,-1.42,2.89],[-14.96,-1.39,3.25],[-14.64,-1.36,3.61],[-14.32,-1.33,3.97],[-14.0,-1.3,4.34],[-13.68,-1.27,4.7],[-13.37,-1.24,5.06],[-13.05,-1.21,5.42],[-12.74,-1.18,5.77],[-12.44,-1.15,6.11],[-12.14,-1.12,6.45],[-11.85,-1.09,6.78],[-11.57,-1.07,7.11],[-11.29,-1.04,7.42],[-11.03,-1.02,7.72],[-10.78,-0.99,8.0],[-10.54,-0.97,8.28],[-10.31,-0.95,8.53],[-10.1,-0.93,8.78],[-9.9,-0.91,9.0],[-9.72,-0.89,9.21],[-9.56,-0.88,9.39],[-9.41,-0.86,9.56],[-9.29,-0.85,9.7],[-9.18,-0.84,9.82],[-9.1,-0.83,9.91],[-9.04,-0.83,9.98],[-9.0,-0.82,10.02],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04],[-8.99,-0.82,10.04]])
		obj.zoom=800
	objArr.push(obj)
*/



var obj= new Object()
	obj.properties={name:'Plane01', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.721569,0.894118,0.6]}
	obj.position=new KeyArray([0.0],[[14.68,-61.62,11.06]])
	obj.orientation=new KeyArray([0.0],[[78.33,15.54,-52.41]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane02', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[47.08,-41.6,11.06]])
	obj.orientation=new KeyArray([0.0],[[73.6,46.38,-67.88]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane03', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[30.38,-50.8,22.47]])
	obj.orientation=new KeyArray([0.0],[[65.81,29.41,-47.57]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane04', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[24.69,-41.6,41.88]])
	obj.orientation=new KeyArray([0.0],[[46.47,24.13,-23.3]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane05', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-7.02,-61.62,18.11]])
	obj.orientation=new KeyArray([0.0],[[71.53,-5.88,17.04]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane06', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[2.99,-41.6,48.93]])
	obj.orientation=new KeyArray([0.0],[[41.46,2.2,-1.96]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane07', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-13.02,-50.8,36.57]])
	obj.orientation=new KeyArray([0.0],[[54,-10.82,14.47]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane08', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-33.23,-41.6,37.16]])
	obj.orientation=new KeyArray([0.0],[[48.61,-28.12,28.13]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane09', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-20.43,-61.62,-0.34]])
	obj.orientation=new KeyArray([0.0],[[90,-19.35,90]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane10', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-46.64,-41.6,18.7]])
	obj.orientation=new KeyArray([0.0],[[67.94,-44.45,59.95]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane11', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-39.84,-50.8,-0.34]])
	obj.orientation=new KeyArray([0.0],[[90,-37.38,90]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane12', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-46.64,-41.6,-19.39]])
	obj.orientation=new KeyArray([0.0],[[112.05,-44.45,120.04]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane13', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-7.02,-61.62,-18.8]])
	obj.orientation=new KeyArray([0.0],[[108.46,-5.88,162.95]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane14', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-33.23,-41.6,-37.85]])
	obj.orientation=new KeyArray([0.0],[[131.38,-28.12,151.86]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane15', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[-13.02,-50.8,-37.26]])
	obj.orientation=new KeyArray([0.0],[[126,-10.82,165.52]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane16', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[2.99,-41.6,-49.62]])
	obj.orientation=new KeyArray([0.0],[[138.53,2.2,-178.05]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane17', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[14.68,-61.62,-11.75]])
	obj.orientation=new KeyArray([0.0],[[101.66,15.54,-127.6]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane18', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[24.69,-41.6,-42.57]])
	obj.orientation=new KeyArray([0.0],[[133.52,24.13,-156.71]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100.01]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane19', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[30.38,-50.8,-23.16]])
	obj.orientation=new KeyArray([0.0],[[114.18,29.41,-132.44]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane20', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[47.08,-41.6,-11.75]])
	obj.orientation=new KeyArray([0.0],[[106.39,46.38,-112.13]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane21', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[62.78,-10.2,-0.34]])
	obj.orientation=new KeyArray([0.0],[[89.99,82.78,-90]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane22', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[56.59,22.2,-19.39]])
	obj.orientation=new KeyArray([0.0],[[-129.06,64.82,131.87]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane23', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.721569,0.6]}
	obj.position=new KeyArray([0.0],[[61.78,12,-0.34]])
	obj.orientation=new KeyArray([0.0],[[-90,79.18,89.99]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane24', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[56.59,22.2,18.7]])
	obj.orientation=new KeyArray([0.0],[[-50.95,64.82,48.12]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane25', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[18.69,-10.2,60.34]])
	obj.orientation=new KeyArray([0.0],[[7.58,17.85,-2.34]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane26', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[34.89,22.2,48.57]])
	obj.orientation=new KeyArray([0.0],[[-23.02,32.31,12.79]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane27', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[18.39,12,59.39]])
	obj.orientation=new KeyArray([0.0],[[-11.36,17.66,3.48]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane28', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-1.33,22.2,60.34]])
	obj.orientation=new KeyArray([0.0],[[-19.3,1.41,0.49]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane29', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-52.64,-10.2,37.16]])
	obj.orientation=new KeyArray([0.0],[[12.15,-53.38,9.8]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane30', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-36.44,22.2,48.93]])
	obj.orientation=new KeyArray([0.0],[[-23.81,-35.08,-14.23]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane31', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-51.83,12,36.57]])
	obj.orientation=new KeyArray([0.0],[[-18.01,-52.63,-14.48]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane32', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-58.83,22.2,18.11]])
	obj.orientation=new KeyArray([0.0],[[-46.36,-62.84,-43.02]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane33', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-52.64,-10.2,-37.85]])
	obj.orientation=new KeyArray([0.0],[[167.84,-53.38,170.19]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane34', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-58.83,22.2,-18.8]])
	obj.orientation=new KeyArray([0.0],[[-133.65,-62.84,-136.99]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane35', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-51.83,12,-37.26]])
	obj.orientation=new KeyArray([0.0],[[-162,-52.63,-165.53]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane36', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-36.44,22.2,-49.62]])
	obj.orientation=new KeyArray([0.0],[[-156.2,-35.08,-165.78]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane37', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[18.69,-10.2,-61.02]])
	obj.orientation=new KeyArray([0.0],[[172.41,17.85,-177.67]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane38', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[-1.33,22.2,-61.02]])
	obj.orientation=new KeyArray([0.0],[[-160.71,1.41,179.5]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane39', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[18.39,12,-60.07]])
	obj.orientation=new KeyArray([0.0],[[-168.65,17.66,176.51]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane40', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[34.89,22.2,-49.25]])
	obj.orientation=new KeyArray([0.0],[[-156.99,32.31,167.2]])
	obj.scale=new KeyArray([0.0],[[-100.01,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane41', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.894118,0.6,0.721569]}
	obj.position=new KeyArray([0.0],[[50.6,10.21,37.16]])
	obj.orientation=new KeyArray([0.0],[[-12.16,53.37,9.8]])
	obj.scale=new KeyArray([0.0],[[-100.01,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane42', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[34.4,-22.19,48.93]])
	obj.orientation=new KeyArray([0.0],[[23.8,35.07,-14.23]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane43', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[49.79,-11.99,36.57]])
	obj.orientation=new KeyArray([0.0],[[17.99,52.62,-14.48]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane44', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[56.78,-22.19,18.11]])
	obj.orientation=new KeyArray([0.0],[[46.35,62.83,-43.02]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane45', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-20.74,10.21,60.34]])
	obj.orientation=new KeyArray([0.0],[[-7.59,-17.86,-2.34]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane46', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-36.94,-22.19,48.57]])
	obj.orientation=new KeyArray([0.0],[[23.01,-32.32,12.79]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane47', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-20.43,-11.99,59.39]])
	obj.orientation=new KeyArray([0.0],[[11.35,-17.67,3.48]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane48', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-0.71,-22.19,60.34]])
	obj.orientation=new KeyArray([0.0],[[19.29,-1.42,0.49]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane49', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-64.82,10.21,-0.34]])
	obj.orientation=new KeyArray([0.0],[[-90.01,-82.79,-90.01]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane50', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-58.64,-22.19,-19.39]])
	obj.orientation=new KeyArray([0.0],[[129.05,-64.83,131.87]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane51', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-63.83,-11.99,-0.34]])
	obj.orientation=new KeyArray([0.0],[[90,-79.19,90]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane52', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-58.64,-22.19,18.7]])
	obj.orientation=new KeyArray([0.0],[[50.94,-64.83,48.12]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane53', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-20.74,10.21,-61.02]])
	obj.orientation=new KeyArray([0.0],[[-172.42,-17.86,-177.67]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane54', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-0.71,-22.19,-61.02]])
	obj.orientation=new KeyArray([0.0],[[160.7,-1.42,179.5]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane55', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-20.43,-11.99,-60.07]])
	obj.orientation=new KeyArray([0.0],[[168.64,-17.67,176.51]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane56', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[-36.94,-22.19,-49.25]])
	obj.orientation=new KeyArray([0.0],[[156.98,-32.32,167.2]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane57', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[50.6,10.21,-37.85]])
	obj.orientation=new KeyArray([0.0],[[-167.85,53.37,170.19]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane58', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[56.78,-22.19,-18.8]])
	obj.orientation=new KeyArray([0.0],[[133.64,62.83,-136.99]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane59', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.345098,0.345098,0.882353]}
	obj.position=new KeyArray([0.0],[[49.79,-11.99,-37.26]])
	obj.orientation=new KeyArray([0.0],[[162,52.62,-165.53]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane60', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[34.4,-22.19,-49.62]])
	obj.orientation=new KeyArray([0.0],[[156.19,35.07,-165.78]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane61', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[4.98,61.63,18.11]])
	obj.orientation=new KeyArray([0.0],[[-71.54,5.87,17.04]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane62', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-5.04,41.61,48.93]])
	obj.orientation=new KeyArray([0.0],[[-41.47,-2.21,-1.96]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane63', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[10.97,50.81,36.57]])
	obj.orientation=new KeyArray([0.0],[[-54.01,10.81,14.47]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane64', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[31.19,41.61,37.16]])
	obj.orientation=new KeyArray([0.0],[[-48.62,28.11,28.13]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane65', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-16.72,61.63,11.06]])
	obj.orientation=new KeyArray([0.0],[[-78.34,-15.55,-52.41]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane66', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-49.12,41.61,11.06]])
	obj.orientation=new KeyArray([0.0],[[-73.61,-46.39,-67.88]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane67', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-32.42,50.81,22.47]])
	obj.orientation=new KeyArray([0.0],[[-65.82,-29.42,-47.57]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane68', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-26.74,41.61,41.88]])
	obj.orientation=new KeyArray([0.0],[[-46.48,-24.14,-23.3]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane69', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-16.72,61.63,-11.75]])
	obj.orientation=new KeyArray([0.0],[[-101.67,-15.55,-127.6]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane70', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-26.74,41.61,-42.57]])
	obj.orientation=new KeyArray([0.0],[[-133.53,-24.14,-156.71]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100.01]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane71', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-32.42,50.81,-23.16]])
	obj.orientation=new KeyArray([0.0],[[-114.19,-29.42,-132.44]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane72', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[-49.12,41.61,-11.75]])
	obj.orientation=new KeyArray([0.0],[[-106.4,-46.39,-112.13]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane73', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[4.98,61.63,-18.8]])
	obj.orientation=new KeyArray([0.0],[[-108.47,5.87,162.95]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane74', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[31.19,41.61,-37.85]])
	obj.orientation=new KeyArray([0.0],[[-131.39,28.11,151.86]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane75', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.341176,0.878431,0.776471]}
	obj.position=new KeyArray([0.0],[[10.97,50.81,-37.26]])
	obj.orientation=new KeyArray([0.0],[[-126,10.81,165.52]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane76', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.580392,0.694118,0.101961]}
	obj.position=new KeyArray([0.0],[[-5.04,41.61,-49.62]])
	obj.orientation=new KeyArray([0.0],[[-138.54,-2.21,-178.05]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane77', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.580392,0.694118,0.101961]}
	obj.position=new KeyArray([0.0],[[18.39,61.63,-0.34]])
	obj.orientation=new KeyArray([0.0],[[-90,19.34,89.99]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane78', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.580392,0.694118,0.101961]}
	obj.position=new KeyArray([0.0],[[44.6,41.61,18.7]])
	obj.orientation=new KeyArray([0.0],[[-67.95,44.44,59.95]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane79', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.580392,0.694118,0.101961]}
	obj.position=new KeyArray([0.0],[[37.79,50.81,-0.34]])
	obj.orientation=new KeyArray([0.0],[[-90,37.37,89.99]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

var obj= new Object()
	obj.properties={name:'Plane80', parent:'undefined', aeClass:'Solid', width:10, height:10, color:[0.580392,0.694118,0.101961]}
	obj.position=new KeyArray([0.0],[[44.6,41.61,-19.39]])
	obj.orientation=new KeyArray([0.0],[[-112.06,44.44,120.04]])
	obj.scale=new KeyArray([0.0],[[-100,-100,-100]])
objArr.push(obj)

/*
for(i=1;i<=comp.layers.length;i++){
	comp.layers[i].orientation.setValuesAtTimes([0.0],[[0,50,60]])
	}
*/

app.beginUndoGroup('3dsmax import')
// main loop
	for (obj in objArr){
		var obj=objArr[obj]
		var layer=comp.layers.byName(obj.properties.name)

		if(!layer)layer=addAEObject(obj.properties)
		
/*
		
		var t=obj.orientation.t
		alert(t.constructor.name)
		var v=obj.orientation.v
		if(prop=='orientation'){
			layer['orientation'].setValuesAtTimes(t,v)
			}
*/
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