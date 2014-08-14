obj = $Sphere01
cam = $Camera01
wOut = tan(cam.fov/2) * cam.targetDistance * 2
wIn = obj.radius*2
ratio=wIn/wOut

cam2 = $Camera02
wOut/cam.targetDistance/2 == tan(cam.fov/2)
atan(wOut/cam2.targetDistance/2)*2  == cam2.fov

