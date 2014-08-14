// get 1st layer
item=app.project.activeItem.layers[1]


// set a marker
var myMarker = new MarkerValue("Fade Up");
item.property("Marker").setValueAtTime(2, myMarker);


// remove first marker
item.property("Marker").removeKey(1)


// remove all markers
for (i=item.property("Marker").numKeys;i>=1;i--)item.property("Marker").removeKey(i)

