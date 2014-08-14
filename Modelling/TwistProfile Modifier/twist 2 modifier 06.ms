-- plugin:		twist profile
-- author:		dave stewart
-- date:		01 October 2006
-- version:		0.8
-- www:			www.davestewart.co.uk/maxscripts

-- purpose:		twists geometry based on an f-curve. Useful for controlling twist / bank before applying a path deform

-- comments:	unfinished due to max randomly freezing, and issues with loading the correct f-curve when multiple modifiers in scene
--				feel free to edit amend, and please let me know if / when you solve any problems!
--				cheers, dave.

plugin simpleMod twistProfileScripted
name:"Twist Profile (scripted)"
classID:#(0x2d60fac1, 0x2d0524a1)
(
	
	
	----------------------------------------------------------------------------------
	-- local vars
	----------------------------------------------------------------------------------
	
		local roCC
		local theMod = this
	
	----------------------------------------------------------------------------------
	-- curve control
	----------------------------------------------------------------------------------
	
		include "curve control 06.ms"
		
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
				--label lblAxis "Axis: " across:2
				--radiobuttons rdoAxis "" labels:#("X","Y","Z") align:#right columns:3
				
			----------------------------------------------------------------------------------
			-- handlers	
			
				on params open do
				(
					try (removeRollout roCC);catch()
					roCC.init this
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
			-- skip if 0
				if i == 0 then return p
			
				--format "% \n" i
			
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
