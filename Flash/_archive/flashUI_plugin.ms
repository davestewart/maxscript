plugin modifier flashPos 
name:"Flash Position" 
classID:#(0x31c84d27, 0x7945884e)
version:1 
( 

	parameters main rollout:params 
	( 
		--amount type:#integer ui:amtSpin default:20 
	) 
	rollout params "Saddle Parameters" 
	( 
		local flashFile = getDir #scripts + "\\new\\flash testing\\axisControl.swf"
		ActiveXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[13,7] width:100 height:100 fileName:flashFile
	) 
	on rFlash open do
	( 
		--axFlash.movie = flashFile  
		--axFlash.movie = flashFile  -- need to load 2nd time sometimes 
	)
) 
