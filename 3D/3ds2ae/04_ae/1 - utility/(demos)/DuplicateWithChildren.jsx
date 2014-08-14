{
	// DupWithChildren.jsx
	//
	// This script works on a single layer selected within the active comp.
	// It duplicates this layer, as well as all its child layers.
	// 

	function dupeIt(comp, layer) {
		var layer_copy = layer.duplicate();
		
		for(var i = 1; i<= comp.numLayers; i++) {
			if(comp.layer(i).parent == layer) {
				var kd_copy = dupeIt(comp, comp.layer(i));
				kd_copy.parent = layer_copy;
			}
		}
		layer_copy.moveToEnd();
		return layer_copy;
	}

	var proj = app.project;
	var undoStr = "Duplicate With Children";

	if (proj){
		var okayToDuplicate = true;

		var activeItem = app.project.activeItem;
		if (activeItem == null || !(activeItem instanceof CompItem)){
			okayToDuplicate = false;
		} else {
			if (activeItem.selectedLayers.length != 1) {
				okayToDuplicate = false;
			}
		}
		if (okayToDuplicate) {
			// Duplicate the selected layer within the active comp.
			var activeComp = activeItem;
			var layerToDupe = activeComp.selectedLayers[0];
			app.beginUndoGroup(undoStr);
			dupeIt(activeComp, layerToDupe);
			app.endUndoGroup();
		} else {
			alert("No changes were made. Please set an active comp and select a single layer to run this script.");
		}
	} else {
		alert("Open a project first to use this script.");
	}
}


