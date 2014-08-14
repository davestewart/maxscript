obj=app.project.item(1).layer(1)
prop=obj.property("Rotation").value//.addKey(time)

//for(p in prop)str+=prop[p]+"\n"
//str+=obj.name+"\n"

str=obj.property("Masks").property("Mask 1").propertyGroup().name



obj=app.project.item(1).layer(1)
str=""

str=obj("Masks").property("Mask 1").property("Mask Shape").value.vertices


// this doesn't work
var myShape = new Shape();
myShape.vertices = [ [0,0], [0,1], [1,1], [1,0] ];
myShape.closed = true;

obj("Masks").property("Mask 1").property("Mask Shape").value.vertices=[ [0,0], [0,1], [1,1], [1,0], [20,20] ]
//alert(obj)
