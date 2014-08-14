---------------------------------------------------------------------------------
-- utility functions
--
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



	fn getBounds obj baseObject:false=
		(
		local n, xf, size
		xf=xform()
		n=if base==true then obj.modifiers.count else 0
		addModifier obj xf before:n
		classof obj
		size=(getModContextBBoxMax obj xf - getModContextBBoxMin obj xf)
		deleteModifier obj xf
		return round size
		)



---------------------------------------------------------------------------------
-- space conversion functions
--
	local mxYUP=matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]--XZY
	local mxZUP=matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]--XYZ

	global getPos 
	fn getPos obj =
		(
		local v= obj.pos
		local p3=Point3 (round v.x) (-round v.z) (round v.y)
		format "pos>: % %\n" v p3
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
		local v=obj.scale*100
		local p3=Point3 (round v.x) (round v.z) (round v.y)
		return p3
		)

	fn getAnchor obj =
		(
		local bounds=getBounds obj
		--bounds=[100,50,0]
		format "%\n" bounds
		local x=bounds.x/2 - obj.objectoffsetpos.x
		local y=bounds.y/2 + obj.objectoffsetpos.y
		local z=0
		local v=[x,y,z]
--		local p3=round (Point3 v.x -v.z v.y)
		local p3=Point3 (round v.x) (round v.y) (round -v.z)
		format "%\n" p3
		return p3
		)

---------------------------------------------------------------------------------
-- object property conversion functions
--

	fn getRollAngle obj =
		(
		v=obj[3][2].value
		local p3=Point3 0 0 (round v)
		return p3
		)

	fn getCamZoom obj v:renderwidth= --*renderPixelAspect -- is this needed?
		(
		return round ((v/2)/(tan (obj.fov/2)))
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

	fn getColor obj =
		(
		if classof obj != Color then obj=obj.color
		return point3 (obj.r/255.0) (obj.g/255.0) (obj.b/255.0)
		)

	fn getSolidColor obj =
		(
		if obj.material!=undefined then
			try(return (getColor obj.material.Diffuse))
			catch(return (getColor obj.wirecolor))
		else return (getColor obj.wirecolor)
		)

	fn getTime t =
		(
		return t as float/4800
		)
		

---------------------------------------------------------------------------------
-- Main function to get animation values 
--

	fn getKeyArray obj prop =
		(
		format "PROCESSING: %\n" obj.name
		--local vArr=for t = 25 to 50 collect (at time t getPos obj)
		--for t = 25 to 50 do at time t print  (getPos obj)

		print vArr
	
		--------------------------------------------------
		-- variables
			local coord=#world
			local inc=1--5
			local ctrl
	
		--------------------------------------------------
		-- which function should be called to get values?
			local getValueFn=case prop of
				(
				#pos:getPos
				#position:getPos
				#rotation:getRot
				#scale:getScale
				#pivot:getAnchor
				#roll:getRollAngle
				#fov:getCamZoom
				#multiplier:getLightIntensity
				#falloff:getLightConeAngle
				#hotspot:getLightConeFeather
				#lightColor:getLightColor
				#color:getColor
				#time:getTime
				)
	
		--------------------------------------------------
		-- keyframe code
	
			-- set up a temp controller to store key times
				if prop==#roll then	ctrl=obj[3][2].controller
				else
					(
					try (ctrl=getProperty (getNodeByName obj.name) (prop as string+".controller"))
					catch()
					)
				--execute ("$'"+obj.name+"'."+prop as string+".controller")
		
			-- if no controller, return a value
				if ctrl==undefined then return "new KeyArray([0],["+(getValueFn obj as string)+"])"

			-- if controller, get object's key times
				local keyCtrl=getKeyTimes ctrl
			

			-- add extra frames if needed
				if keyCtrl.keys.count > 1 then
					(
					for t = keyCtrl.keys[1].time to keyCtrl.keys[keyCtrl.keys.count].time by inc do addNewKey keyCtrl t
					sortKeys keyCtrl
					)
				else addNewKey keyCtrl 0
		
				local frames=for k in keyCtrl.keys collect k.time
	
		--------------------------------------------------
		-- Main code
	
			-- times / values
				local tArr=for t in frames collect (getTime t)
				local vArr=for t in frames collect (at time t getValueFn obj)
				print tArr
		
			-- convert to stringstream
				local tStr=stringstream ""
				local vStr=stringstream ""
				local sStr=stringstream ""
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
	
				format "new KeyArray([%],[%])" (tStr as string) (vStr as string) to:sStr
			-- return
				--return #(tStr,vStr)
				return sStr as string
		)


