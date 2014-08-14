{ 
// make sure a comp is selected 
	var activeItem = app.project.activeItem; 
	if (activeItem == null || !(activeItem instanceof CompItem)){ 
	alert("You need to select a comp first."); 
	
	}
	else { 
	// create loop to check each layer in comp. 
	str=""
		for (var f = 1; f <= activeItem.numLayers; ++f) { 
		currentLayer = activeItem.layer(f); 
		//alert("Searching layer " + f + ": " + currentLayer.name); 
		
		// search top level properties for "Effects" 
			for (var g = 1; g <= currentLayer.numProperties; ++g) { 
				if (currentLayer.property(g).name == "Effects") { 
				currentEffects = currentLayer.property(g); 
				
				// check each of the effects 
					for (var h = 1; h <= currentEffects.numProperties; ++h) { 
					thisEffect = currentEffects.property(h); 
					
					// check each property 
						for (var i = 1; i <= thisEffect.numProperties; ++i) { 
						thisParam = thisEffect.property(i); 
						
						if (thisParam.propertyValueType == PropertyValueType.NO_VALUE) { valueType = "NO_VALUE"; } 
						if (thisParam.propertyValueType == PropertyValueType.TwoD_SPATIAL) { valueType = "TwoD_SPATIAL"; } 
						if (thisParam.propertyValueType == PropertyValueType.TwoD) { valueType = "TwoD"; } 
						if (thisParam.propertyValueType == PropertyValueType.OneD) { valueType = "OneD"; } 
						if (thisParam.propertyValueType == PropertyValueType.COLOR) { valueType = "COLOR"; } 
						if (thisParam.propertyValueType == PropertyValueType.CUSTOM_VALUE) { valueType = "CUSTOM_VALUE"; } 
						
						//alert(thisEffect.name + " " + thisParam.name + " " + valueType) 
						str+=currentLayer.name+" : "+thisEffect.name + " " + thisParam.name + " " + valueType+"\n"
						alert(PropertyValueType)//(thisParam.propertyValueType))
						} 
					} 
				} 
			} 
		} 
	alert(str)
	} 
}