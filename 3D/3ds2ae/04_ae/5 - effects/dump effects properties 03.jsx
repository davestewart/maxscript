// functions
	function createFile(name,str){
		f = File(name)
		f.open('w','????','????')
		f.writeln(str)
		f.close()
		return f
		}
		
	function createFolder(str){
		var result	= Folder(str).create()
		var fld	= Folder(Folder.current.toString()+'/'+str)
		if(result){
			return fld
			}
		else{
			if(fld.exists){
				//alert('Folder '+fld.toString()+' already exists!')
				return fld
				}
			//else alert('Folder '+fld.toString()+' could not be created')
			}
		}

	function getPropertyValueTypeNames(prop){
		var ptv=prop.propertyValueType
		if(ptv==PropertyValueType.NO_VALUE) return'NO_VALUE'
		if(ptv==PropertyValueType.ThreeD_SPATIAL) return'ThreeD_SPATIAL'
		if(ptv==PropertyValueType.ThreeD) return'ThreeD'
		if(ptv==PropertyValueType.TwoD_SPATIAL) return'TwoD_SPATIAL'
		if(ptv==PropertyValueType.TwoD) return'TwoD'
		if(ptv==PropertyValueType.OneD) return'OneD'
		if(ptv==PropertyValueType.COLOR) return'COLOR'
		if(ptv==PropertyValueType.CUSTOM_VALUE) return'CUSTOM_VALUE'
		if(ptv==PropertyValueType.MARKER) return'MARKER'
		if(ptv==PropertyValueType.LAYER_INDEX) return'LAYER_INDEX'
		if(ptv==PropertyValueType.MASK_INDEX) return'MASK_INDEX'
		if(ptv==PropertyValueType.SHAPE) return'SHAPE'
		if(ptv==PropertyValueType.TEXT_DOCUMENT) return'TEXT_DOCUMENT'
		return prop.name
		}
	

	function pad(d){
		var str=""
		for(var i=0;i<d;i++)str+="	"
		return str
		}
	

// code
	// functions
	
		function listEffectProperties(effect){
			txt=''
			txt+='[name]\n'
			txt+='name='+effect.name+'\n'
			txt+='matchName='+effect.matchName+'\n\n'
			
			txt+='[properties]\n'
			for(var j=1;j<=effect.numProperties;j++){
				var prop=effect.property(j)
				//txt+=pad(prop.propertyDepth)
				//txt+=prop.propertyType+' - '
				//txt+=prop.isEffect+' - '
				if(prop.elided)txt+='*'
				txt+='name=	'+prop.name+'\n'
				txt+='type=	'+getPropertyValueTypeNames(prop)+'\n'
				//txt+='matchName=	'+prop.matchName+'\n'
				txt+='\n'
				}
			return txt
			}
	
		function listEffects(layer){
			var txt=''
			var effects=layer.Effects
			for(var i=1;i<=effects.numProperties;i++){
				var effect=effects.property(i)
				}
			return txt
			}
			

	// variables
		var comp=app.project.items[1]
		var layer=comp.layers[1]


	// set current folder
		var root=Folder('/E/03_Scripting/3ds2ae/04_ae/1 - utility/filesystem stuff/')
		Folder.current=root
		root=createFolder('Effects')
		Folder.current=root
		
	// start iterating
		for(var i=1;i<=comp.layers.length;i++){
			// get layer name and create folder
				var layer=comp.layers[i]
				var fld=createFolder(layer.name)
				Folder.current=fld

			// get layer effects
				var effects=layer.Effects
				for(var j=1;j<=effects.numProperties;j++){
					// get effect
						var effect=effects.property(j)
					// get effect properties
						var str=listEffectProperties(effect)
					// write file
						createFile(effect.name+'.txt',str)
					}

			// return to root folder
				Folder.current=root
		 	}
