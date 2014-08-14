
arr=app.project.activeItem.selectedLayers

// doesn't work!
//app.project.activeItem.selectedLayers=arr


for(i=1;i<=5;i++)app.project.activeItem.layers[i].selected=true
app.project.activeItem.layers[1].Masks("Mask 1").selected=true

app.project.activeItem.selectedProperties

app.project.activeItem.layers[1].selectedProperties

