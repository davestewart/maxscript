{
	// This script scales the selected layers within the active comp.
	//
	// First, it prompts the user for a scale_factor via a modal dialog.
	// 
	// Next, it scales all selected layers, including cameras.

	// This variable stores the scale_factor
	var scale_factor = 1.0;
	var scale_about_center = true;

	//
	// This function is called when the user clicks the "Scale about Upper Left" button
	//
	function onCornerButtonClick()
	{
		scale_about_center = false;
	}

	//
	// This function is called when the user clicks the "Scale about Upper Left" button
	//
	function onCenterButtonClick()
	{
		scale_about_center = true;
	}

	//
	// This function is called when the user enters text for the scale.
	//
	function on_textInput_changed()
	{
		// set the scale_factor based on the text, then close the dialog.
		if ( isNaN(this.text) ) {
			alert(this.text + "is not a number. Please enter a number.");
		} else {
			scale_factor = this.text;
		}
	}

	// 
	// This function puts up a modal dialog asking for a scale_factor.
	// Once the user enters a value, the dialog closes, and the script scales the comp.
	// 
	function BuildAndShowDialog()
	{	
		// build the dialog
		var my_dialog = new Window("dialog","Scale Comp");
		my_dialog.bounds = [200,200,450,410];
		my_dialog.add("statictext", [10, 10, 250, 30], "Type value for scaling.");
		my_dialog.add("statictext", [10, 35, 250, 55], "Press \"Enter\" key when ready.");

		var cornerButton = my_dialog.add("radiobutton", [30,  65, 190,  85], "Scale about Upper Left");
		var centerButton = my_dialog.add("radiobutton", [30,  90, 190,  110], "Scale about Center");
		centerButton.value = true;
		cornerButton.onClick = onCornerButtonClick;
		centerButton.onClick = onCenterButtonClick;

		var text_input = my_dialog.add("edittext", [30, 145, 130, 165], "1.0");

		okButton     = my_dialog.add("button", [10, 175,120,195],"OK",     {name:'ok'} );
		cancelButton = my_dialog.add("button", [130,175,240,195],"Cancel", {name:'cancel'});

		// set the callback. When the user enters text, this will be called.
		text_input.onChange = on_textInput_changed;

		// display the dialog.
		return my_dialog.show();
	}

	// 
	// Sets newParent as the parent of all layers in theComp that don't have parents.
	// This includes 2D/3D lights, camera, av, text, etc.
	//
	function makeParentLayerOfUnparentedInArray(layerArray, newParent)
	{
		for (var i = 0; i < layerArray.length; i++) {
			var curLayer = layerArray[i];
			if (curLayer != newParent &&
			    curLayer.parent == null) {
			 	curLayer.parent = newParent;
			}
		}
	}

	//
	// Scales the zoom factor of every camera by the given scale_factor.
	// Handles both single values and multiple keyframe values.
	function scaleCameraZoomsInArray(layerArray, scaleBy)
	{
		for (var i = 0; i < layerArray.length; i++) {
			var curLayer = layerArray[i];
			if (curLayer.matchName == "ADBE Camera Layer") {
				var curZoom = curLayer.zoom;
				if (curZoom.numKeys == 0) {
					curZoom.setValue(curZoom.value * scaleBy);
				} else {
					for (var j = 1; j <= curZoom.numKeys; j++){
						curZoom.setValueAtKey(j,curZoom.keyValue(j)*scaleBy);
					}
				}
			}
		}
	}

	// 
	// The main script.
	//
	var activeItem = app.project.activeItem;
	if (activeItem == null || !(activeItem instanceof CompItem)){
		alert("Please establish a comp as the active item and run the script again");
	} else {
		var selectedLayers = activeItem.selectedLayers;
		if (activeItem.selectedLayers.length == 0) {
			alert("Please select at least one layer in the active comp and run the script again.");
		} else {

		    if (BuildAndShowDialog() == 1) {

			// The script will only execute what's below AFTER the modal dialog has 	
			// has been exited with OK or return.
			// The value returned will be 2 if cancel button is clicked.

			var activeComp = activeItem;

			// By bracketing the operations with begin/end undo group, we can 
			// undo the whole script with one undo operation.
			app.beginUndoGroup("Scale Selected Layers");

			// Create a null 3D layer.
			var null3DLayer = activeItem.layers.addNull();
			null3DLayer.threeDLayer = true;

			// Set it's position to (0,0,0)
			if (scale_about_center) {
				null3DLayer.position.setValue([activeComp.width * 0.5, activeComp.height * 0.5,0]);
			} else {
				null3DLayer.position.setValue([0, 0, 0]);
			}
			
			// Set null3DLayer as parent of all layers that don't have parents.  
			makeParentLayerOfUnparentedInArray(selectedLayers, null3DLayer);

			// Then for all cameras, scale the Zoom parameter proportionately.
			scaleCameraZoomsInArray(selectedLayers, scale_factor);

			// Set the scale of the super parent null3DLayer proportionately.
			var superParentScale = null3DLayer.scale.value;
			superParentScale[0] = superParentScale[0] * scale_factor;
			superParentScale[1] = superParentScale[1] * scale_factor;
			superParentScale[2] = superParentScale[2] * scale_factor;
			null3DLayer.scale.setValue(superParentScale);

			// Delete the super parent null3DLayer with dejumping enabled.
			null3DLayer.remove();
	
			// everything we just did changed the selection. Reselect those
			// same layers again.
			for (var i = 0; i < selectedLayers.length; i++) {
				selectedLayers[i].selected = true;
			}

			app.endUndoGroup();
		    }
		}
	}
}