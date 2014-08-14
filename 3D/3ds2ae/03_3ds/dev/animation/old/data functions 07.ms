(
---------------------------------------------------------------------------------
-- variables
--

	local coord=#world

---------------------------------------------------------------------------------
-- utility functions
--

	fn round val n:2=
		(
		local p=10^n
		val=floor(val*p)/p
		if abs val < 0.1 then val=0
		return val
		)


	local drill
	fn getKeyTimes c=
		(
		try(
		-- create temporary controller
			local ctrl=execute((classof c as string)+"()")

		-- recursive function
			fn drill c &ctrl=
				(
				for k in c.keys do addNewKey ctrl.keys k.time
				for i = 1 to c.numSubs do
					(
					sa=getSubAnim c i
					if sa.controller!=undefined then drill sa &ctrl
					)
				)
	
		-- drill
			drill c &ctrl
			sortKeys ctrl
			return ctrl
			)
		catch(return undefined)
		)



---------------------------------------------------------------------------------
-- space conversion functions
--
	local mxYUP=matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]--XZY
	local mxZUP=matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]--XYZ

	fn getPos obj =
		(
		local v=obj.pos
		local p3=Point3 (round v.x) (-round v.z) (round v.y)
		return p3
		)

	fn getRot obj =
		(
		in coordsys mxYUP local v=obj.rotation as eulerangles
		local p3=Point3 (round -v.x) (round v.y) (round v.z)
		return p3
		)

	fn getScale obj =
		(
		local v=obj.scale
		local p3=Point3 (round v.x) (round v.z) (round v.y)
		return p3
		)

---------------------------------------------------------------------------------
-- object property conversion functions
--

	fn getCamZoom obj h:600=
		(
		return round ((h.value/2)/(tan (obj.fov/2)))
		)

	fn getLightIntensity obj =
		(
		return obj.multiplier*100
		)

	fn getLightConeAngle obj =
		(
		return obj.falloff
		)

	fn getLightConeFeather obj =
		(
		return round (100-(obj.hotspot/obj.falloff*100))
		)

	fn getColor col =
		(
		return point3 (col.r/255.0) (col.g/255.0) (col.b/255.0)
		)

	fn getTime t =
		(
		return t as float/4800
		)
		

---------------------------------------------------------------------------------
-- cycle 2
--


fn getValues obj=
	(
	-- get object's key times
		local ctrl=getKeyTimes obj.position.controller

	-- add extra frames
		for t = 0 to animationrange.end by 5 do addNewKey ctrl t
		sortKeys ctrl
		local frames=for k in ctrl.keys collect k.time

	-- times / values
		local tArr=for t in frames collect (getTime t)
		local vArr=for t in frames collect (at time t getPos obj)

	-- convert to stringstream
		local tStr=stringstream ""
		local vStr=stringstream ""
		for i = 1 to tArr.count do
			(
			format "%" tArr[i] to:tStr
			format "%" vArr[i] to:vStr
			if i<tArr.count then
				(
				format "," to:tStr
				format "," to:vStr
				)
			)

	-- return
		return #(tStr,vStr)
	)



	(
	t=timestamp()
	arr=getValues $
	format "[%],\n[%]\n" (arr[1] as string) (arr[2] as string)
	format "DONE: %\n" (timestamp()-t)
	)
/*
*/
)