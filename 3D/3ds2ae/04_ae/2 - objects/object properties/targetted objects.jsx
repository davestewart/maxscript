obj=app.project.activeItem.layers[3]
v=obj.canAddProperty("Point of Interest")
//alert(v)
//obj.propertyGroup(1).addProperty("Point of Interest")
//obj("Point of Interest").setValue([0,0,0])
cam=app.project.activeItem.layers.addCamera("cam1",[50,50])
cam.pointOfInterest.expression="position"
cam.pointOfInterest.expressionEnabled=true