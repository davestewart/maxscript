plugin simpleMod twistProfile
name:"-Twist Profile"
classID:#(0x2d60fac1, 0x2d0524a1)
	(
	
	
	----------------------------------------------------------------------------------
	-- local vars
	----------------------------------------------------------------------------------
	
		local roCC
		local theMod = this
		local firstRun = true 
	
	----------------------------------------------------------------------------------
	-- curve control
	----------------------------------------------------------------------------------
	
		include "curve control 05.ms"
		
	----------------------------------------------------------------------------------
	-- parameters
	----------------------------------------------------------------------------------
	
		parameters main rollout:params
			(
			valTwist 		type:#float default:10
	
			pPoints			type:#point3Tab tabSizeVariable:true --values:#([0,0,0],[1000,0,0])
			pTangents		type:#point4Tab tabSizeVariable:true
			pBeziers		type:#boolTab tabSizeVariable:true
			pCorners		type:#boolTab tabSizeVariable:true
			)

	----------------------------------------------------------------------------------
	-- main rollout
	----------------------------------------------------------------------------------
	
		rollout params "Parameters"
			(
			
			----------------------------------------------------------------------------------
			-- ui
			
				button btnProfile "Edit profile..." width:160 height:20 align:#center
				label lblAxis "Axis: " across:2
				radiobuttons rdoAxis "" labels:#("X","Y","Z") align:#right columns:3
				
			----------------------------------------------------------------------------------
			-- handlers	
			
				on params open do
					(
					try (removeRollout roCC);catch()
					roCC.init this
					if firstRun == true then
						(
						firstRun = false
						)
					)
			
				on btnProfile pressed do
					(
					createdialog roCC 820 464 -- modal:true
					roCC.init this
					)
				)


	----------------------------------------------------------------------------------
	-- animation
	----------------------------------------------------------------------------------

		on map i p do
			(
			-- skip if the rollout is undefined
				if roCC == undefined then
					(
					p
					return false
					)
			
			-- ratio of how far along geometry the point is
				local dy	= (p.y / extent.y) + 0.5

			-- get the values
				if roCC.cc1.curves != undefined then
					(
					-- value
						local val	= getValue roCC.cc1.curves[1] 0 (1000 * dy)
						
					-- local vars
						local x = p.x
						local y = p.y
						local z = p.z
						
					-- rotate the points
						p.x = cos(val) * x - sin(val) * z
						p.z = cos(val) * z + sin(val) * x
						--p.y = cos(val) * z + sin(val) * y
					)
			-- set the value
				p
			)
	)
