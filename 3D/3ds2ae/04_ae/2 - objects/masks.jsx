// creates masks for Beethoven Uncovered
// basically lozenge shapes - solids with round edges

var colorArr=new Array(
				[1,0,0],
				[0,1,0],
				[0,0,1]
				)

var widthArr=new Array(
				100,
				75,
				35
				)

function createKey (w,x,y,n){
	// variables
		w=200
		h=12
		c=0.53*(h/2)
	
	
	// object
		obj = app.project.items[1].layers.addSolid(colorArr[n], "Solid 1", w, h, 1, 10)
	
	// position
		obj.anchorPoint.setValue([0,h/2,0])
		obj.position.setValue([x,y,0])
	
	// mask
		newMask = obj.Masks.addProperty("ADBE Mask Atom");
		newMask.maskMode = MaskMode.ADD;
		newMask.color=colorArr[0]//[0,0,0]
		newMask.locked=true
		
		myProperty = newMask.property("ADBE Mask Shape");
		myShape = myProperty.value;
		myShape.vertices = [ [0,h/2], [h/2,0], [w-1-h/2,0], [w-1,h/2], [w-1-h/2,h], [h/2,h] ]
		myShape.inTangents = [ [0,c], [-c,0], [0,0], [0,-c], [c,0], [0,0] ]
		myShape.outTangents = [ [0,-c], [0,0], [c,0], [0,c], [0,0], [-c,0] ]
		
		myShape.closed = true;
		myProperty.setValue(myShape);
	}

var x=0
for(i=0;i<widthArr.length;i++){
	w = widthArr[i]
	createKey(w,x,100,i)
	x += w
	}
