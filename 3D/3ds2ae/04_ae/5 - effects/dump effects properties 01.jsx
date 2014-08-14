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


comp=app.project.items[1]
layer=comp.layers[1]
txt=''

function listEffects(layer){
	var txt=''
	var effects=layer.Effects
	for(var i=1;i<=effects.numProperties;i++){
		var effect=effects.property(i)
		txt+='\n'
		txt+='	['+effect.name+']'+'\n'
		txt+='		matchName=\t'+effect.matchName+'\n\n'
		
		for(var j=1;j<=effect.numProperties;j++){
			var prop=effect.property(j)
			//txt+=pad(prop.propertyDepth)
			//txt+=prop.propertyType+' - '
			//txt+=prop.isEffect+' - '
			//txt+=prop.propertyValueType+' '
			if(prop.elided)txt+='*'
			txt+='		name=		'+prop.name+'\n'
			//txt+='		pVT=		'+getPropertyValueTypeNames(prop)+'\n'
			//txt+='		matchName=	'+prop.matchName+'\n'
			}
		}
	return txt
	}

/*
 */
comp=app.project.items[1]
txt=''
for(i=1;i<=comp.layers.length;i++){
	layer=comp.layers[i]
	//effects=layer.Effects
	txt+='\n\n'+layer.name+'\n'
	txt+=listEffects(layer)
 	}

//alert(effects.property(1).property(5).propertyValueType==PropertyValueType.ThreeD)
//alert(PropertyValueType[effects.property(1).property(5).propertyValueType])
//alert(comp.layers[1].Effects.property(1).property(3).propertyValueType)
alert(txt)
txt.saveToFile()