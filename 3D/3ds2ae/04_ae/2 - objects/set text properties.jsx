function setText(str,size){
	app.preferences.savePrefAsString("Text Style Sheet", "Font Family Name", str) 
	app.preferences.savePrefAsLong("Text Style Sheet", "Size", size) 
	app.preferences.saveToDisk(); 
	app.preferences.reload(); 
	}

comp=app.project.activeItem

setText("Arial", 50)
alert(app.preferences.getPrefAsString("Text Style Sheet", "Font Family Name"))
app.preferences.reload(); 
comp.layers.addSolid([1,1,1], '', 50, 50, 1, 50)
comp.layers.addText("Hello!")

setText("Verdana", 20)
comp.layers.addText("Goodbye!")
/*

obj=app.preferences//.savePrefAsLong("Text Style Sheet", "Font Family Name", str.toString()) 
str=''
for( prop in obj){
	str+=prop+'\n'
	}
alert(str)
*/
obj=comp.layers[1].property('Text')
str=''
for( prop in obj){
	str+=prop+'\n'
	}
alert(str)
