fn getCameraTransform cam =
(
	--this will return a camera transform matrix, ignoring perspective for now:
		local ct	= cam.transform
		local ctd	= cam.target_distance
		local f		= cam.fov
		local d		= cam.dir
		local p		= cam.pos
		
		local row1	= ct.row1*((2*tan(f/2))*ctd)
		local row2	= (ct.row2*((2*tan(f/2))*ctd))*(renderheight/renderwidth as float)/renderpixelaspect
		local row3	= d * ctd
		
		local ctx	= inverse (matrix3 row1 row2 row3 p)
		
		return ctx
)


fn worldToCam pt3 cam ctx:undefined =
(
	-- get camera transform
		if ctx == undefined then ctx = getCameraTransform cam
	
	--this will transform your point into camera space, still sans perspective:
		pt3			*= ctx

	--this will sort out the perspective:
		pt3.x		/= pt3.z
		pt3.y		/= pt3.z
	
	--this will get you a pixel location:
		local pixloc = ([-pt3.x, pt3.y, 0] + 0.5) * [renderwidth, renderheight, 0]
	
	--and a Z-depth if you need one:
		zdepth = pt3.z * cam.target_distance

	-- return
		return pixloc 
)
	
worldToCam $.pos $camera01