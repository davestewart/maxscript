{
	//Velocity Arrows:
	//       This script creates one new layer for each selected layer in the active comp.
	//       Each layer contains an arrow that gives velocity feedback.
	//       The position of the arrow tracks the selection;
        //       the rotation and scale of the arrow indicate the selection's velocity.
	//	 Note that the arrow is updated continuously and automatically,
	// 	 because its transform values are given by expressions that are based
	//	 on the source layer.
	//
	// Naming:
	// 	The name of each new layer is the name of the original layer, with the 
	//	suffix "_v" appended.  The original layer name will be truncated if it is
	//	more than 29 letters long, so that the total name fits within the maximum
	//	of 31 letters.
	//
	// Color and Shape:
	//      Hard-coded in this script to a purple color and arrow shape.
	//	To change, users can edit this script, or edit the layers once created.
	//
	// Overall Scale:
	//	The arrow will scale up and down in proportion to the magnitude of the
	// 	velocity. The overall scale of the arrow can be changed via
	//	the effects slider in the velocity arrow's layer.

	// Change these if you want your arrow to look different.
	var arrowColor        = [1, 0, 1];
	var arrowShapeVertices = [[171, 79],  [158, 55],   [146, 81],   [153, 76],  
				  [157, 76],  [157, 95],   [157,110],   [155,117],   
				  [159,116],  [163,117],   [161,110],   [160, 95],
				  [160, 76],  [165, 77]];
	var arrowSolidSize    = 250;

	// The first number is a hard limit for layer names in AfterEffects and can't change.
	var maxLayerNameSize = 31;
	var arrowLayerNameSuffix = "_v";

	// Creates a velocity arrow that tracks the given sourceLayer.
	function createVelocityArrow(theComp, sourceLayer)
	{
		// name the arrow using up to sourceLayer, followed by the the suffix
		var maxCharsFromSourceName = maxLayerNameSize - arrowLayerNameSuffix.length;
		var arrowName;
		if (sourceLayer.name.length > maxCharsFromSourceName){
			arrowName = sourceLayer.name.substring(0,maxCharsFromSourceName) + arrowLayerNameSuffix;
		} else {
			arrowName = sourceLayer.name + arrowLayerNameSuffix;
		}

		// Create a solid
		var arrowLayer = theComp.layers.addSolid(arrowColor, arrowName, arrowSolidSize, arrowSolidSize, 1.0);

		// Make it a guide layer
		arrowLayer.guideLayer = true;

		// If layer being tracked is a 3d layer, make the arrow a 3d layer too.
		if (sourceLayer.threeDLayer == true) {
			arrowLayer.threeDLayer = true;
		}

		// Move it right before the sourceLayer
		arrowLayer.moveBefore(sourceLayer);

		// Add the arrow-shaped mask
		var newMask    = arrowLayer.mask.addProperty("ADBE Mask Atom");
		var arrowShape = new Shape();
		arrowShape.vertices = arrowShapeVertices;
		newMask.maskShape.setValue(arrowShape);

		// Create the effect slider that multiplies overall size.
		// Its value will be used in the scale expression below.
		var sizeSlider = arrowLayer.effect.addProperty("ADBE Slider Control");
		sizeSlider("ADBE Slider Control-0001").setValue(100);

		// In the expressions,
		// the sourceLayer is generally referred to as the layer with an 
		// index of arrowLayer+1.
		// Using names is not always good, since sometimes multiple layers
		// have the same name.
		// Using the index of sourceLayer means that the expressions will break
		// if either of the layers is moved.
		// Using arrowIndex+1 means that, so long as the arrowLayer remains just
		// atop the sourceLayer, things will keep working.

		// Set position as an expression that tracks the source layer:
		// The expression will read:    thisComp.layer(index+1).position
		arrowLayer.position.expression = "thisComp.layer\(index+1\).position";

		// set anchor point:
		arrowLayer.anchorPoint.setValue([160,120,0]);

		// A little trig never hurt anyone...
		// For rotation, the expression will read:
		// "tempPos = thisComp.layer(index+1).position; 
		//  nextFrameTime = time + thisComp.frameDuration;
		//  yDiff = tempPos.valueAtTime(nextFrameTime)[1]-tempPos[1];
		//  xDiff = tempPos.valueAtTime(nextFrameTime)[0]-tempPos[0];
		//  90+radiansToDegrees(Math.atan2(yDiff,xDiff))"	
		arrowLayer.rotation.expression = 
				        "tempPos = thisComp.layer\(index+1\).position;" +
					"nextFrameTime = time + thisComp.frameDuration;" +
					"yDiff = tempPos.valueAtTime(nextFrameTime)[1]-tempPos[1];" +
					"xDiff = tempPos.valueAtTime(nextFrameTime)[0]-tempPos[0];" +
					"90+radiansToDegrees(Math.atan2(yDiff,xDiff))";

		// Set the expression for scale:
		// The expression will read:
		// "pos = thisComp.layer(index+1).position; 
                //  nextFrameTime = time + thisComp.frameDuration; 
		//  vel = (pos.valueAtTime(nextFrameTime)-pos.value)/(nextFrameTime-time); 
		//  sliderScale = effect("Slider Control")("Slider");
		//  [sliderScale,sliderScale * 0.5*length(vel)]"
		arrowLayer.scale.expression = 
				        "pos = thisComp.layer\(index+1\).position;" +
					"nextFrameTime = time + thisComp.frameDuration;" +
					"vel = (pos.valueAtTime(nextFrameTime)-pos.value)/(nextFrameTime-time);" +
					"sliderScale = effect\(\"ADBE Slider Control\"\)\(\"ADBE Slider Control-0001\"\);" +
					"[sliderScale, sliderScale * 0.01 * 0.5*length(vel)];";

		
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

			var activeComp = activeItem;

			// By bracketing the operations with begin/end undo group, we can 
			// undo the whole script with one undo operation.
			app.beginUndoGroup("Velocity Arrows");

			// Create a velocity arrow for each selected layer.
			for (var i = 0; i < selectedLayers.length; i++) {
				createVelocityArrow(activeComp, selectedLayers[i]);
			}

			app.endUndoGroup();
		}
	}
}