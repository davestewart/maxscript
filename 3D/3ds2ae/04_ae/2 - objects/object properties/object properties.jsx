bigStr=""

comp=app.project.activeItem
arr=comp.selectedProperties
str=comp.selectedLayers[0].name+"\n"
for(i=0;i<arr.length;i++){
	str+="	"+String(arr[i].name)+"	"+arr[i].propertyValueType+"\n"
	}
bigStr+=str+"\n"
alert(bigStr)

//alert(comp.layers[1].property("Position").propertyValueType)