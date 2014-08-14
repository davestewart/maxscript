{
// This function applies the effect to one single layer
//
	function applyFastBlurToLayer(the_layer)
		{
		var addedIt = false;

		// Can only add an effect if there's an effects group in the layer.
		// Some layers don't have one, like camera and light layers.
			if (the_layer("Effects") != null ) {
		
				// Always best to check if it's safe before adding:
					if (the_layer("Effects").canAddProperty("Fast Blur")) {
		
					// add a new Fast Blur effect to the effects group of the layer
						the_layer("Effects").addProperty("Fast Blur");
		
					// set the parameter values
						the_layer("Effects")("Fast Blur").blurriness.setValue(10);
						the_layer("Effects")("Fast Blur").repeatEdgePixels.setValue(true);
						addedIt = true;
					}
				
				}
		// Return a boolean saying whether we added the effect
			return addedIt ;
		}

// Start an undo group. By using this with an endUndoGroup(), you
// allow users to undo the whole script with one undo operation.

	app.beginUndoGroup("Apply Fast Blur to Selections");

// If we don't find any selected layers, we'll put up an alert at the end.
	var numLayersChanged = 0;

// Get the active comp
	var activeItem = app.project.activeItem;
		if (activeItem != null && (activeItem instanceof CompItem)){
			var activeComp = activeItem;

			// try to apply to every selected layer
				var selectedLayers = activeComp.selectedLayers;
				for (var i = 0; i < selectedLayers.length; i++) {
					var curLayer = selectedLayers[i];
	
					// The method returns true if it adds the effect, false otherwise.
						if (applyFastBlurToLayer(curLayer) == true) {
							numLayersChanged++;
							}
					}
			}
// Print a message if no layers were affected
	if (numLayersChanged == 0) {
	alert("Please select an AV layer or layers and run script again");
	}
app.endUndoGroup();
}