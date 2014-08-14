{
	// This script will create an Adjustment layer in the activeComp.
	// The adjstment layer will have Cineon Converter effect with Gamma = 2.2 and
	// Highlight Rolloff = 0.
	//
	// note: This script is using matchName so that this script can work with localized build.
	// 

	var activeItem = app.project.activeItem;
	if (activeItem == null || !(activeItem instanceof CompItem)){
	    alert("Please establish a comp as the active item and run the script again");
	} else {

		// By bracketing the operations with begin/end undo group, we can 
		// undo the whole script with one undo operation.
		app.beginUndoGroup("Cineon Adjust");

		var activeComp = activeItem;

		var solidName = "log2lin";
		var solidW = activeComp.width;
		var solidH = activeComp.height;
		var solidPixelAspectRatio = activeComp.pixelAspect;
		var solidDuration = activeComp.duration;

		var adjLayer = activeComp.layers.addSolid([1, 1, 1], solidName, solidW, solidH, solidPixelAspectRatio, solidDuration);

		// apply Cineon Converter.
		
		var cineon = adjLayer.Effects.addProperty("ADBE Cineon Converter");

		// Set Values
		// 
		// gamma to 2.2 on windows, 1.7 on mac
		if (system.osName.indexOf("Windows") != -1){
			cineon.property("ADBE Cineon Converter-0006").setValue(2.2);
		} else {
			cineon.property("ADBE Cineon Converter-0006").setValue(1.7);
		}
		// Highlight Rolloff to 0
		//
		cineon.property("ADBE Cineon Converter-0007").setValue(0);

		adjLayer.adjustmentLayer = true;
		adjLayer.guideLayer = true;
		adjLayer.moveToBeginning();

		app.endUndoGroup();
	}
}
