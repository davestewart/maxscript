
/*

app.project.item(index).layer(index).property(1).property(index).
*/
//alert(obj.property("maskShape").value)

/*
obj=app.project.item(1).layers.addSolid([1,0,0], "Solid 1", 200, 6, 1, 10)

var myShape = new Shape();
myShape.vertices = [ [0,0], [0,1], [1,1], [1,0] ];
myShape.closed = true;


//newMask = obj.Masks.addProperty("ADBE Mask Atom");
newMask = obj.Masks.addProperty("mask");
newMask.maskMode = MaskMode.ADD;


w=obj.width
h=obj.height

myProperty = newMask.property("ADBE Mask Shape");
myShape = myProperty.value;
myShape.vertices = [ [0,h/2], [h/2,0], [w-h/2,0], [w,h/2], [w-h/2,h], [h/2,h]];
myShape.closed = true;
myProperty.setValue(myShape);


app.project.activeItem.name="dave"

for(i=1;i<10;i++){
	for(j=1;j<10;j++){
		
		}
	}
alert([i,j])
*/
//alert(layer.mask(1).maskShape.value)
//alert(layer.mask(1).maskShape.value.vertices[3][0])
/*
s=new Shape()
str=''
for(p in s)str+=(p+' :'+s[p].toString()+'\n')
alert(str)
*/