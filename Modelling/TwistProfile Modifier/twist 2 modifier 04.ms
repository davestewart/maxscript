

plugin simpleMod twistProfile
name:"-Twist Profile"
classID:#(0x2d60fac1, 0x2d0524a1)
(
	
	
	----------------------------------------------------------------------------------
	-- local vars
	----------------------------------------------------------------------------------
	
		local roCC 
		local firstRun = true
		local ro = this
	
	----------------------------------------------------------------------------------
	-- curve control
	----------------------------------------------------------------------------------
	
		include "curve control 04.ms"
		
	----------------------------------------------------------------------------------
	-- parameters
	----------------------------------------------------------------------------------
	
		parameters main rollout:params
		(
			valTwist 		type:#float ui:spnTwist default:20
			valValue		type:#float ui:spnVal default:20
	
			twistVals		type:#point3Tab tabSizeVariable:true
			twistValsIn		type:#point3Tab tabSizeVariable:true
			twistValsOut	type:#point3Tab tabSizeVariable:true
		)
	----------------------------------------------------------------------------------
	-- main rollout
	----------------------------------------------------------------------------------
	
		rollout params "Parameters"
		(
			
			----------------------------------------------------------------------------------
			-- ui
			
				button btn1 "Edit profile" width:160 height:20 align:#center
				button btn2 "Check values" width:160 height:20 align:#center
				
				--label lblAxis "Axis : " across:2
				--radiobuttons rdoAxis "" labels:#("X","Y","Z") align:#right columns:3
				
				spinner spnTwist "Twist : " type:#float range:[-2000,2000,20] fieldWidth:50 align:#right
				spinner spnVal 	"Value : " type:#float range:[-2000,2000,20] fieldWidth:50 align:#right


			----------------------------------------------------------------------------------
			-- handlers	
			
				on params open do removeRollout roCC
			
				on btn1 pressed do
				(
					createdialog roCC 820 464
				)
					
				on btn2 pressed do
				(
					local val = getValue roCC.cc1.curves[1] 0 750
					print val
				)
			)


	----------------------------------------------------------------------------------
	-- animation
	----------------------------------------------------------------------------------


	/*

	on map i p do
	(
		print p

		local iy = p.y / extent.y

		local val = valTwist * (iy + 0.5)
		x = p.x
		y = p.y
		z = p.z

		p.x = cos(val) * x - sin(val) * z
--			p.y = cos(val) * z + sin(val) * y
		p.z = cos(val) * z + sin(val) * x
		p
	)
*/
	
		on map i p do
		(
			-- ratio of how far along geometry the point is
				local dy	= (p.y / extent.y) + 0.5

			-- actual value
				local val	= valTwist * dy
				
				--format "% % %\n" val p iy
				
				--print i
				local curves = roCC.cc1.curves
				if curves != undefined then
				(
					local val	= getValue roCC.cc1.curves[1] 0 (1000 * dy)
					--format " -- %\n" roCC.cc1.curves[1]
					
					--format "curve: %\n" val
		
				-- local vars
					local x = p.x
					local y = p.y
					local z = p.z
				-- rotate the points
					p.x = cos(val) * x - sin(val) * z
		--			p.y = cos(val) * z + sin(val) * y
					p.z = cos(val) * z + sin(val) * x
				)
				
			--p.z += val
				
			p
		)

	/*
	*/
)


/*


roCC.cc1.zoomValues = [0.7,0.4]
roCC.width = 820

zoom roCC.cc1 #all


*/