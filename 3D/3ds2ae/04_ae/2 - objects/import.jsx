// imports a comp to use a layer as a placeholder.
// For instance you can't crrently construct a non-ratget camera, so the bets thing is to import a ready-made one

var libraryComp=undefined

function importLibrary(){
	try{var tmp=libraryComp.name}
	catch(err){libraryComp=undefined}
	if(libraryComp==undefined){
		var io, libraryFolder
		io = new ImportOptions( File( "library.aep" ) );
		io.canImportAs(ImportAsType.COMP )
		libraryFolder=app.project.importFile(io)
		libraryComp=libraryFolder.items[1]
		}
	}
	
function removeLibrary(){
	libraryComp.parentFolder.remove()
	libraryComp=undefined
	}

function addObject(objType,objName,comp){
	var layer=libraryComp.layers.byName(objType)
	if(layer!=undefined){
		layer.copyToComp(comp)
		comp.layers[1].name=objName
		}
	}

comp=app.project.items[1]
importLibrary()
addObject('Point','Point 345',comp)
removeLibrary()
