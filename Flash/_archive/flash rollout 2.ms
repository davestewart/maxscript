rollout rFlash "Shockwave Flash Object" 
( 
	local txtObj
	local flashFile = "D:\\Design\\1 - 3D\\3dsmax4\\scripts\\new\\flash testing\\button.swf"
	
	fn checkTextObject = 
		( 
		if $text01 == undefined then 
			( 
			txtObj = text text:"" name:"text01" 
			addModifier txtObj (extrude amount:10) 
			txtObj.wirecolor = red 
			rotate txtObj 90 x_axis 
			) 
		else
			(
			txtObj = $text01
			) 
		) 

	activeXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" height:200 width:200 align:#left 

	on axFlash OnReadyStateChange arg1 do format "handler: OnReadyStateChange : %\n" arg1 

	on axFlash OnProgress arg1 do format "handler: OnProgress : %\n" arg1 

	on axFlash FSCommand arg1 arg2 do 
		( 
		checkTextObject() 
		txtObj.text = arg1 + "+" + arg2 
		max tool zoomextents all 
		) 

	on rFlash open do 
		( 
		axFlash.movie = flashFile  
		axFlash.movie = flashFile  -- need to load 2nd time sometimes 
		checkTextObject(); 
		) 
) 
flashFloater = newRolloutFloater "Shockwave Flash Object" 250 300 10 10 
addRollout rFlash flashFloater 
