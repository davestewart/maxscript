function saveTextFile(str,filePath){
	tf=new File(filePath)
	tf.open('w','TEXT','????');
	tf.writeln(str)
	tf.close()
	}

function getAllComps(){
	str=''
	if(app.project){
		items=app.project.items
		for(i=1;i<=items.length;i++){
			obj=items[i]
			if(obj.typeName=='Composition'){
				arr=[obj.name,obj.width,obj.height,obj.pixelAspect,obj.frameRate,obj.duration]
				if(obj==app.project.activeItem)arr.push(true)
				str+=arr.join('	')+'\n'
				}
			}
		if(str!=''){
			saveTextFile(str,'comps.dat')
			alert('Comp list updated.\n\n(Now switch back to max!)')
			}
		else alert('This project doesn\'t contain any comps.')
		}
	else{
		alert('You need to have a project open before importing comp names.')
		}
	}

getAllComps()
