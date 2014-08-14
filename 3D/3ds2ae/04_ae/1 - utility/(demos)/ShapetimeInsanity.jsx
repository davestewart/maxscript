{
	//
	//
	// Creates a new comp containing hollow squares, rings, and triangles,
	// with keyframes for random position, rotation, opacity and scale
	//
	// Created by Dan Ebberts.
	 

	// By bracketing the operations with begin/end undo group, we can 
	// undo the whole script with one undo operation.
	app.beginUndoGroup("Shapetime Insanity");

	// variable declarations
	 
	var compW = 640; // comp width
	var compH = 480; // comp height
	var compT = 8; // comp length (seconds)
	var compBG = [.19,.25,.33]; // comp background color
	 
	var n = 60; // number of items to create
	var w = 75; // width of solid
	var d = 5; // thickness of shape border
	var segMin = 1.5; // min duration of random motion segment
	var segMax = 2.5; // max duration
	 
	var r = w/2; // radius of circle
	var ratio = .5523 // ratio of handle size to radius for circle masks
	 
	var minR = 96;   // min amount of red in solid
	var maxR = 192;  // max amount of red in solid
	var minG = 96;   // min amount of green in solid
	var maxG = 192;  // max amount of green in solid
	var minB = 192;  // min amount of blue in solid
	var maxB = 224;  // max amount of blue in solid
	 
	var minPos = [0,0]; // min xy position of solid
	var maxPos = [compW,compH];
	var minRot = -720;  // min rotation
	var maxRot = 720;   // max rotation
	var minOpat = 40;   // min opacity
	var maxOpat = 100;  // max opacity
	var minScale = 40;  // min scale
	var maxScale = 100; // max scale
	var red, green, blue; // color components of solid
	var mySolid;
	var newMask;
	var myProperty;
	var myShape;
	var myIn, myOut; // in and out points
	var x,y,s,t,delta;// various temp variables
	var newPos, newRot,newScale,newOpat;
	 
	// create project if necessary
	 
	var proj = app.project;
	if(!proj)
	proj = app.newProject();
	 
	// create new comp named 'shapes'
	 
	var myItemCollection = app.project.items;
	var myComp = myItemCollection.addComp('shapes',compW,compH,1,compT,29.97);
	myComp.bgColor = compBG;
	 
	// begin loop to create "n" hollow shapes
	 
	for (var j = 1; j < n+1; j++){
	 
	  // get random color for new solid
	 
	  red = (minR + Math.random()*(maxR-minR))/255;
	  green = (minG + Math.random()*(maxG-minG))/255;
	  blue = (minB + Math.random()*(maxB-minB))/255;
	 
	  if (j <= n/3){ // first 1/3 of solids will be squares
	 
	    mySolid = myComp.layers.addSolid([red,green,blue], "square", w, w, 1);
	    mySolid.blendingMode = BlendingMode.SCREEN; //set blending mode to screen

	    // set up inner rectangular mask to make square hollow

	    newMask = mySolid.Masks.addProperty("ADBE Mask Atom");
	    newMask.maskMode = MaskMode.SUBTRACT;
	    myProperty = newMask.property("ADBE Mask Shape");
	    myShape = myProperty.value;
	    myShape.vertices = [[d,d],[d,w-d],[w-d,w-d],[w-d,d]];
	    myShape.closed = true;
	    myProperty.setValue(myShape);
	 
	  }else if (j <= 2*n/3){ // second 1/3 of solids will be rings
	 
	    mySolid = myComp.layers.addSolid([red,green,blue], "ring", w, w, 1);
	    mySolid.blendingMode = BlendingMode.SCREEN; //set blending mode to screen
	 
	    // set up outer circular mask
	 
	    t = r*ratio; //tangent offset
	    newMask = mySolid.Masks.addProperty("ADBE Mask Atom");
	    newMask.maskMode = MaskMode.ADD;
	    myProperty = newMask.property("ADBE Mask Shape");
	    myShape = myProperty.value;
	    myShape.vertices = [[r,0],[0,r],[r,2*r],[2*r,r]];
	    myShape.inTangents = [[t,0],[0,-t],[-t,0],[0,t]];
	    myShape.outTangents = [[-t,0],[0,t],[t,0],[0,-t]];
	    myShape.closed = true;
	    myProperty.setValue(myShape);
	 
	    // set up inner circular mask
	 
	    t = (r-d)*ratio;
	    newMask = mySolid.Masks.addProperty("ADBE Mask Atom");
	    newMask.maskMode = MaskMode.SUBTRACT;
	    myProperty = newMask.property("ADBE Mask Shape");
	    myShape = myProperty.value;
	    myShape.vertices = [[r,d],[d,r],[r,2*r-d],[2*r-d,r]];
	    myShape.inTangents = [[t,0],[0,-t],[-t,0],[0,t]];
	    myShape.outTangents = [[-t,0],[0,t],[t,0],[0,-t]];
	    myShape.closed = true;
	    myProperty.setValue(myShape);
	 
	  }else{ // final 1/3 of solids will be triangles
	 
	    mySolid = myComp.layers.addSolid([red,green,blue], "triangle", w, w, 1);
	    mySolid.blendingMode = BlendingMode.SCREEN; //set blending mode to screen
	 
	    // set up outer triangular mask
	 
	    newMask = mySolid.Masks.addProperty("ADBE Mask Atom");
	    newMask.maskMode = MaskMode.ADD;
	    myProperty = newMask.property("ADBE Mask Shape");
	    myShape = myProperty.value;
	    myShape.vertices = [[0,0],[w,0],[w/2,w*.866]];
	    myShape.closed = true;
	    myProperty.setValue(myShape);
	 
	    // set up inner triangular mask
	 
	    newMask = mySolid.Masks.addProperty("ADBE Mask Atom");
	    newMask.maskMode = MaskMode.SUBTRACT;
	    myProperty = newMask.property("ADBE Mask Shape");
	    myShape = myProperty.value;
	    myShape.vertices = [[1.73*d,d],[w-1.73*d,d],[w/2,w*.866-2*d]];
	    myShape.closed = true;
	    myProperty.setValue(myShape);
	  }
	 
	  // add keyframes for random motion
	 
	  myIn = mySolid.inPoint;
	  myOut = mySolid.outPoint;
	 
	  // add position keyframes
	 
	  myProperty = mySolid.property("position");
	  t = myIn - segMin*Math.random();
	  while(t < myOut + segMax){
	    x = minPos[0] + Math.random()*(maxPos[0] - minPos[0]);
	    y = minPos[1] + Math.random()*(maxPos[1] - minPos[1]);
	    newPos = [x,y];
	    myProperty.setValueAtTime(t,newPos);
	    delta = segMin + Math.random()*(segMax - segMin);
	   t += delta;
	  }
	 
	  // add rotation keyframes
	 
	  myProperty = mySolid.property("rotation");
	  t = myIn - segMin*Math.random();
	  while(t < myOut + segMax){
	    newRot = minRot + Math.random()*(maxRot - minRot);
	    myProperty.setValueAtTime(t,newRot);
	    delta = segMin + Math.random()*(segMax - segMin);
	   t += delta;
	  }
	 
	  // add opacity keyframes
	 
	  myProperty = mySolid.property("opacity");
	  t = myIn - segMin*Math.random();
	  while(t < myOut + segMax){
	    newOpat = minOpat + Math.random()*(maxOpat - minOpat);
	    myProperty.setValueAtTime(t,newOpat);
	    delta = segMin + Math.random()*(segMax - segMin);
	   t += delta;
	  }
	 
	  // add scale keyframes
	 
	  myProperty = mySolid.property("scale");
	  t = myIn - segMin*Math.random();
	  while(t < myOut + segMax){
	    s = minScale + Math.random()*(maxScale - minScale);
	    newScale = [s,s];
	    myProperty.setValueAtTime(t,newScale);
	    delta = segMin + Math.random()*(segMax - segMin);
	   t += delta;
	  }
	}

	app.endUndoGroup();
}
