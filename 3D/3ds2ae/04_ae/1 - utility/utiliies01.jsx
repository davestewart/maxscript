function listProps(){
	if(app.project){
	// variables
		var item=app.project.activeItem
		var propsStr='Properties:\n'
		
	// code
		for(i in item){
			propsStr+='	'+i+'\n'
			}
		alert(item.name +'\n\n'+propsStr)
		}

	// list
	else alert('You need to have a project loaded to run scripts')
	}


//listProps()

function listProjectItems(){
	// variables
		var obj=app.project.items
		var propsStr='Properties:\n'

	// code
		for(i=1;i<obj.length;i++){
//			propsStr+='	'+i+' : '+item[i]+'\n'
			//alert(obj[i])
			propsStr+=obj[i].name+' : '+obj[i].typeName+'\n'

			//'Folder','Footage','Composition'

			}
	// list
		alert(obj.name +'\n\n'+ propsStr)
	}

	
function listCompObjects(obj){
	alert(obj.typeName)
	alert(obj.name)
	}
	
//listProps()
//listProjectItems()
//listCompObjects(app.project.activeItem)

function getItemByName(str){
	var obj=app.project.items
	for(i=1;i<=obj.length;i++){
		if(obj[i].name==str)return obj[i]
		}
	return null
	}


function applyEffect(layer,effect)
	{
	var addedIt = false;

	// Can only add an effect if there's an effects group in the layer.
	// Some layers don't have one, like camera and light layers.
		if (layer("Effects") != null ) {
	
			// Always best to check if it's safe before adding:
				if (layer("Effects").canAddProperty(effect)) {
	
				// add a new Fast Blur effect to the effects group of the layer
					layer("Effects").addProperty(effect);
	
				// set the parameter values
					layer("Effects")(effect).blurriness.setValue(10);
					layer("Effects")(effect).repeatEdgePixels.setValue(true);
					addedIt = true;
				}
			
			}
	// Return a boolean saying whether we added the effect
		return addedIt ;
	}

	
	
function doSomethingWithComp(str){
	var comp=getItemByName(str)
	//alert(comp.name)
	comp.layers.addSolid([1,1,1], 'new layer', 100, 100, 1, 3)
	applyEffect(comp.layers[2],"Fast Blur")
	}

	
//doSomethingWithComp('Comp 1')
function listLayers(){
	str=''
	item=app.project.activeItem.layers
	for(i=1;i<=item.length;i++){
			str+=item[i].source.fileName+'\n'
			}
	alert(str)
	}

function getProps(item,inOrder){
	var arr=[]; var str=""
	//item=app.project.activeItem.layers[i]
	for(i in item){
		try{
			if(typeof(item[i])!='function'){
				var val=String(i)+' : '+String(item[i])
				arr.push(val)
				str+=val+"\n"
				}
			//str+=typeof(item[i])+'\n'
			}
		catch(err){}
		}
	if(inOrder==true){
		str=""
		arr.sort()
		for(a in arr)str+=arr[a]+"\n"
		}
	alert(str)
	}

//obj=app.project.activeItem.layers[9]
//obj=app.project.activeItem
getProps(layer)

function resetLayerNames(){
	compLayers=app.project.activeItem.layers
	for(i=1;i<compLayers.length;i++){
		var item=compLayers[i]
		if(item.source!=null)item.name=item.source.name
		}
	}
//alert(unescape(app.project.activeItem.layers[4].source.file))
//alert(app.project.activeItem.layers[2].source)
//resetLayerNames()

/*
function totalTime(){
	t=0
	layers=app.project.activeItem.selectedLayers
	for(i=0;i<layers.length;i++)t+=(layers[i].outPoint*25)-(layers[i].inPoint*25)
	alert(t/25/60)
	}
//totalTime()

//app.project.activeItem.selectedLayers[1].startTime=5
*/

function transProperties(){
	str=''
	item=app.project.activeItem.layers
	str=item[1].transform
	alert(str)
	}
//transProperties()

// get properties of an effect
	obj=app.project.activeItem.layers[1].effect("Glow")
	if(obj!=undefined){
		str=''
		for(i=1;i<obj.numProperties;i++){
			var pName=obj.property(i).name
			var pType=obj.property(i).propertyType
			var pVal=obj.property(i).value
			str+=pName+' '+String(pVal)+'\n'
			}
		alert(str)
		//alert(obj.property('Glow Radius').value)
		//alert(obj.numProperties)
		//alert(obj.property(1).name)
		//alert(("Glow Radius").value)
	}