/*
Cheers for that - I 

changed the order of the y and z axis, 
multiplied the y axis by -1 
set the x rotation to be 90 - x rotation 

and it locks on fine - that said I haven't done any rotation over 180 degrees so I'm setting myself up for a fall - it seems like it should be useable so I'll post both bits in case someone else finds them useful - now to read up on XSI ui bits to package it a bit better.

Again thanks a million!
*/


(
tm = in coordsys world cam.transform
tm = tm - origin.transform
mx = tm * (rotateXMatrix 90)
)

tm.pos
mx.rotation as eulerangles




(in coordsys origin $.rotation) as eulerangles



/*
swap $.transform.row2 $.transform.row3 
[0,9.65599e-007,-1]
[0,9.65599e-007,-1]
$.transform
(matrix3 [1,0,0] [0,9.65599e-007,-1] [0,1,9.65599e-007] [449.476,-7.41744e-005,565.637])
(matrix3 [1,0,0] [0,9.65599e-007,-1] [0,1,9.65599e-007] [449.476,-7.41744e-005,565.637])
getASArrayFromPData()
mx = in coordsys origin $.transform * (rotateXMatrix -90)
(matrix3 [0.798804,0.00179,0.601588] [-0.00143361,0.999998,-0.00107188] [-0.601589,-6.16397e-006,0.798806] [-137.967,64.0331,343.469])
(mx - origin.transform).pos
[-297.967,64.0331,279.469]

tm = $.transform - origin.transform
(matrix3 [-0.201196,-0.601588,0.00178997] [-0.00143361,0.00107188,2] [-0.601589,-1.79881,-6.15517e-006] [-297.967,-343.469,0.0331192])
(matrix3 [0.798804,0.00179,0.601588] [-0.00143361,0.999998,-0.00107188] [-0.601589,-6.16397e-006,0.798806] [22.0329,64.0331,407.469])
tm.pos
$.transform.pos
[-137.967,-343.469,64.0331] - [160,0,64]
*/




obj			= $


tm = in coordsys world cam.transform
tm = tm - origin.transform
mx = tm * (rotateXMatrix 90)


mxYUp		= matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]

--mxYUp		= matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0]

--mxYUp		= matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0]

--scale mxYUp [-1, 1, 1]



mxYUp		= matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0]

preScale mxYUp [-1, 1, 1] false
mxObj		= obj.transform

mxObjYUp	= mxObj * mxYUp

mxObjYUp.pos
mxObjYUp.rotation as eulerangles



b			= box transform:mxCamYUp

mxCam.pos
mxCamYUp.pos


mx2 = mxCamYUp * scaleMatrix [0,-1,0]
mx2.rotation as eulerangles



/*


$box01.transform


radToDeg r.x 
radToDeg r.y
radToDeg r.z 


$.transform = $box02.transform



tm = pf.getParticleTMByID 50
pf.getParticleOrientationByID 50

tm.rotation as eulerangles


(tm * mxYUp).rotation as eulerangles
*/




cam1 = $'Camera - Main'

cam2 = $'Camera - Main01'
cam2.transform *= matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
cam2.transform *= rotateXMatrix -90

cam2.rotation as eulerangles
cam2.position

cam1.rotation as eulerangles
cam2.rotation as eulerangles


cam2.transform *= matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0]


matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0]
rotateXMatrix -90

identity $.transform

tm = xformMat (rotateXMatrix -90) (matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0])
b = box transform:tm isselected:true
