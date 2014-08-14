plugin simpleMod twist2
name:"- Twist 2"
classID:#(0xadd2234, 0x41d27996)
version:1
	( 
	local mx
	local iy
	local useMatrix = false
	local x, y, z
	local val
	
	parameters main rollout:params
		(
		twist			type:#integer ui:spnTwist default:20
		
		twistVals		type:#point3Tab tabSizeVariable:true
		twistValsIn		type:#point3Tab tabSizeVariable:true
		twistValsOut	type:#point3Tab tabSizeVariable:true

		)
	rollout params "Parameters"
		(
		spinner spnTwist "Twist : " type:#integer range:[-2000,2000,20] fieldWidth:50 align:#right
		)
		
	on map i p do
		(
		-- ratio of how far along geometry the point is
			iy = p.y / extent.y

			val = twist * (iy + 0.5)
		
			x = p.x
			y = p.y
			z = p.z

			p.x = cos(val) * x - sin(val) * z
--			p.y = cos(val) * z + sin(val) * y
			p.z = cos(val) * z + sin(val) * x

			p

		)
	)
