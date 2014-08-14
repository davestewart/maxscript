comp=app.project.activeItem


function saveTextFile(str,filePath){
	tf=new File(filePath)
	tf.open("w","TEXT","????");
	tf.writeln(str)
	tf.close()
	}

function compToIni(comp){
	var str=""
	str+="[compSettings]\n"
	str+="name="+comp.name+"\n"
	str+="width="+comp.width+"\n"
	str+="height="+comp.height+"\n"
	str+="frameRate="+comp.frameRate+"\n"
	str+="pixelAspect="+comp.pixelAspect+"\n"
	saveTextFile(str,"C:\\temp\\compSettings.ini")
	}
	

function getAllComps(){
	str=""
	items=app.project.items
	for(i=1;i<=items.length;i++){
		obj=items[i]
		if(obj.typeName=="Composition"){
			arr=[obj.name,obj.width,obj.height,obj.pixelAspect,obj.duration,obj.frameRate]
			str+=arr.join("	")+"\n"
			}
		}
	saveTextFile(str,"..\\data\\comps.dat")
	}

getAllComps()
//alert(comp.duration)
alert("Comp list updated.\n\n(Now switch back to max!)")