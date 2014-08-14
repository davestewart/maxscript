c=$Camera01
dependsOn c.fov.controller

-- using height
y=renderHeight/2
a=c.fov/2
zoom=y/(tan a)*1.5

-- using width
y=renderWidth/2
a=c.fov/2
zoom=y/(tan a)

zoom