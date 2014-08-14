{
	// SortByInpoint.jsx
	//
	// This script reorders layers in the active comp, sorted by inPoint.
	//

	var proj = app.project;
	var undoStr = "Sort Layers By inPoint";

	function sortByInpoint(comp_layers, unlockedOnly) {
		
		var total_number = comp_layers.length;
		while(total_number >= 2) {	
			var layer_was_moved = false;
			for (j = 1; j <= total_number; j++) {

				// if you want to reverse the sort order, use "<" instead of ">".
				if(comp_layers[j].inPoint > comp_layers[total_number].inPoint) {
					if(comp_layers[j].locked){
						if(unlockedOnly==false) {
							comp_layers[j].locked = false;
							comp_layers[j].moveAfter(comp_layers[total_number]);
							comp_layers[total_number].locked = true;
							layer_was_moved = true;
						}
					}
					else {
						comp_layers[j].moveAfter(comp_layers[total_number]);
						layer_was_moved = true;
					}
				}
			}
			if (!layer_was_moved) {
				total_number = total_number-1 ;
			}
		}
		
	}

	// change this to true if you want to leave locked layers untouched.
	var unlockedOnly = false;
	if(proj){
		var activeItem = app.project.activeItem;
		if (activeItem != null && (activeItem instanceof CompItem)){
			app.beginUndoGroup(undoStr);
			var activeCompLayers = activeItem.layers;
			sortByInpoint(activeCompLayers, unlockedOnly);
			app.endUndoGroup();
		} else {
			alert("Please select an active comp to use this script");
		}
	}
	else {
		alert("Please open a project first to use this script.");
	}
}