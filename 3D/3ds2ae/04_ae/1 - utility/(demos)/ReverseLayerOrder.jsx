{
	// ReverseLayerOrder.jsx
	// 
	// Reverses the order of all layers in the active comp

	function reverseLayerOrder(myComp){
		var comp_layers = myComp.layers;
		for(j = 1; j <= comp_layers.length/2; j++) {
			var layerToMoveAfter = comp_layers[j];
			var wasLocked = layerToMoveAfter.locked;
			if (wasLocked) {
				layerToMoveAfter.locked = false;
			}
			layerToMoveAfter.moveAfter(comp_layers[comp_layers.length-j+1]);
			if (wasLocked) {
				layerToMoveAfter.locked = true;
			}
			if(comp_layers.length-j != j){
				var layerToMoveBefore = comp_layers[comp_layers.length-j];
				wasLocked   = layerToMoveBefore.locked;
				if (wasLocked) {
					layerToMoveBefore.locked = false;
				}
				layerToMoveBefore.moveBefore(comp_layers[j]);
				if (wasLocked) {
					layerToMoveBefore.locked = true;
				}
			}
		}
	}

	var proj = app.project;
	var undoStr = "Reverse Layer Order";

	if (proj){
		var activeItem = app.project.activeItem;
		if (activeItem != null && (activeItem instanceof CompItem)){
			app.beginUndoGroup(undoStr);
			reverseLayerOrder(activeItem);
			app.endUndoGroup();
		} else {
			alert("Please select an active comp to use this script");
		}
	}
	else
	{
		alert("Please open a project first to use this script.");
	}
}