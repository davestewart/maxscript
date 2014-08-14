plugin simpleMod twist2
name:"Twist 2"
classID:#(0xadd2234, 0x41d27996)
version:1
( 
	
	local mx
	local iy
	
	parameters main rollout:params
	(
		amount type:#integer ui:amtSpin default:20
	)
	rollout params "Saddle Parameters"
	(
		spinner amtSpin "Amount: " type:#integer range:[0,1000,20]
	)
	on map i p do
	(
		
		iy = p.y / extent.y -- ratio of how far along teh geometry the point is
		
		mx = (matrix3 [1,0,0] [0,1,0] [0,0,1] p) -- a matrix3 for the point
		rotateY mx (amount * iy) -- rotate the point

		-- p = mx.positionPart
		
		if i > 0 then
		(
			--format "%: %(%) %\n" i p (classof p) mx
			--format "%:   %   %\n" i p.y iy
		)
		
		mx.translationPart
	)
)



