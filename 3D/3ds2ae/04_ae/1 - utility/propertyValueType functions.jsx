function propertyValueTypeString(prop){
	var str=""
	switch(prop.propertyValueType){
		case 4818: str="NO_VALUE"; break;
		case 4819: str="ThreeD_SPATIAL"; break;
		case 4821: str="ThreeD"; break;
		case 4820: str="TwoD_SPATIAL"; break;
		case 4822: str="TwoD"; break;
		case 4812: str="OneD"; break;
		case 4817: str="COLOR"; break;
		case 4823: str="CUSTOM_VALUE"; break;
		case 4824: str="MARKER"; break;
		case 4814: str="LAYER_INDEX"; break;
		case 4813: str="MASK_INDEX"; break;
		case 4816: str="SHAPE"; break;
		case 4815: str="TEXT_DOCUMENT"; break;
		}
	//return str
	alert([prop.name,prop.propertyValueType,str])
	}

function propertyValueTypeString(prop){
	var str="????"
	if(prop!=null){
		switch(prop.propertyValueType){
			case 4812 : str="NO_VALUE"; break;
			case 4813 : str="ThreeD_SPATIAL"; break;
			case 4814 : str="ThreeD"; break;
			case 4815 : str="TwoD_SPATIAL"; break;
			case 4816 : str="TwoD"; break;
			case 4817 : str="OneD"; break;
			case 4818 : str="COLOR"; break;
			case 4819 : str="CUSTOM_VALUE"; break;
			case 4820 : str="MARKER"; break;
			case 4821 : str="LAYER_INDEX"; break;
			case 4822 : str="MASK_INDEX"; break;
			case 4823 : str="SHAPE"; break;
			case 4824 : str="TEXT_DOCUMENT"; break;			}
		alert([prop.name,String(prop.propertyValueType),str])
		//return str
		}
	else{
		alert('Null value...')
		//return undefined
		}
	}

str=""
arr=["NO_VALUE", "ThreeD_SPATIAL", "ThreeD", "TwoD_SPATIAL", "TwoD", "OneD", "COLOR", "CUSTOM_VALUE", "MARKER", "LAYER_INDEX", "MASK_INDEX", "SHAPE", "TEXT_DOCUMENT"]
for(a in arr){
	str+=eval("PropertyValueType."+arr[a])+ " : " +arr[a] + "\n"
	}
alert(str)
	
	/*
item=app.project.activeItem.layers[1]
var myMarker = new MarkerValue("Fade Up");
item.property("Marker").setValueAtTime(2, myMarker);
*/

comp=app.project.activeItem
layer=comp.layer(1)
/*
//prop=layer.Masks("Mask 1").maskShape//[1]//("Mask 1")//.maskShape//.maskFeather;
prop=layer.effect("Particular")("Size Over Life")

propertyValueTypeString(prop)
alert(prop.value.length)
//alert(prop.value)
*/
prop=layer.effect("Tint")("Map White To")
//prop=layer.scale
prop=layer("Marker")//.keyValue(1)//.comment
prop=layer("Masks")("Mask 1").maskShape//.keyValue(1)//.comment

alert(prop.propertyValueType)