{
	// This script scales the active comp and all the layers within it.
	//
	// First, it prompts the user for a scale_factor, a new comp width, 
	// or a new comp height via a modal dialog.
	// 
	// Next, it scales the comp and all the layers within it, including
	// cameras.

	// This variable stores the scale_factor
	var scale_factor = 1.0;
	var text_input = null;
	var scaleButton  = null;
	var widthButton  = null;
	var heightButton = null;

	function onScaleButtonClick()
	{
		text_input.text = scale_factor;
	}

	function onWidthButtonClick()
	{
		text_input.text = Math.floor(app.project.activeItem.width * scale_factor);
	}

	function onHeightButtonClick()
	{
		text_input.text = Math.floor(app.project.activeItem.height * scale_factor);
	}

	function testNewScale(test_scale)
	{
		var is_ok = true;
		if (test_scale * app.project.activeItem.width < 1 || 
		    test_scale * app.project.activeItem.width > 30000) {
			is_ok = false;
		} else if (test_scale * app.project.activeItem.height < 1 || 
		           test_scale * app.project.activeItem.height > 30000) {
			is_ok = false;
		} 
		return is_ok;
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
			var new_scale_factor;
			if (scaleButton.value == true) {
				new_scale_factor = this.text;
			} else if (widthButton.value == true) {
				new_scale_factor = this.text / app.project.activeItem.width;
			} else {
				new_scale_factor = this.text / app.project.activeItem.height;
			}
			if (testNewScale(new_scale_factor)) {
				scale_factor = new_scale_factor;
			} else {
				alert("value will make height or width out of range 1 to 30000. Reverting to previous value");
				// Load text back in from current values.
				if (scaleButton.value == true) {
					onScaleButtonClick();
				} else if (widthButton.value == true) {
					onWidthButtonClick();
				} else {
					onHeightButtonClick();
				}
			}
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
		my_dialog.add("statictext", [10, 10, 250, 30], "Type value for scale, width, or height.");
		my_dialog.add("statictext", [10, 35, 250, 55], "Press \"Enter\" key when ready.");

		scaleButton  = my_dialog.add("radiobutton", [30,  65, 190,  85], "New Scale Factor");
		widthButton  = my_dialog.add("radiobutton", [30,  90, 190,  110], "New Comp Width");
		heightButton = my_dialog.add("radiobutton", [30, 115, 190,  135], "New Comp Height");
		scaleButton.value = true;
		scaleButton.onClick  = onScaleButtonClick;
		widthButton.onClick  = onWidthButtonClick;
		heightButton.onClick = onHeightButtonClick;

		text_input = my_dialog.add("edittext", [30, 145, 130, 165], "1.0");

		okButtton    = my_dialog.add("button", [10, 175, 120, 195], "OK",      {name:'ok'} );
		cancelButton = my_dialog.add("button", [130,175, 240, 195], "Cancel", {name:'cancel'});

		// set the callback. When the user enters text, this will be called.
		text_input.onChange = on_textInput_changed;

		// display the dialog.
		return my_dialog.show();
	}

	// 
	// Sets newParent as the parent of all layers in theComp that don't have parents.
	// This includes 2D/3D lights, camera, av, text, etc.
	//
	function makeParentLayerOfAllUnparented(theComp, newParent)
	{
		for (var i = 1; i <= theComp.numLayers; i++) {
			var curLayer = theComp.layer(i);
			if (curLayer != newParent &&
			    curLayer.parent == null) {
			 	curLayer.parent = newParent;
			}
		}
	}

	//
	// Scales the zoom factor of every camera by the given scale_factor.
	// Handles both single values and multiple keyframe values.
	function scaleAllCameraZooms(theComp, scaleBy)
	{
		for (var i = 1; i <= theComp.numLayers; i++) {
			var curLayer = theComp.layer(i);
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

		if (BuildAndShowDialog() == 1) {

			// The script will only execute what's below AFTER the modal dialog has 
			// has been exit with OK or return. 
			// The value returned will be 2 if cancel button is clicked.

			var activeComp = activeItem;

			// By bracketing the operations with begin/end undo group, we can 
			// undo the whole script with one undo operation.
			app.beginUndoGroup("Scale Comp");

			// Create a null 3D layer.
			var null3DLayer = activeItem.layers.addNull();
			null3DLayer.threeDLayer = true;

			// Set it's position to (0,0,0)
			null3DLayer.position.setValue([0,0,0]);

			// Set null3DLayer as parent of all layers that don't have parents.  
			makeParentLayerOfAllUnparented(activeComp, null3DLayer);

			// Set new comp width and height.
			activeComp.width  = Math.floor(activeComp.width * scale_factor);
			activeComp.height = Math.floor(activeComp.height * scale_factor);

			// Then for all cameras, scale the Zoom parameter proportionately.
			scaleAllCameraZooms(activeComp, scale_factor);

			// Set the scale of the super parent null3DLayer proportionately.
			var superParentScale = null3DLayer.scale.value;
			superParentScale[0] = superParentScale[0] * scale_factor;
			superParentScale[1] = superParentScale[1] * scale_factor;
			superParentScale[2] = superParentScale[2] * scale_factor;
			null3DLayer.scale.setValue(superParentScale);

			// Delete the super parent null3DLayer with dejumping enabled.
			null3DLayer.remove();

			app.endUndoGroup();
		}
	}
}