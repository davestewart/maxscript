rollout rFlash "Shockwave Flash Object" 
	( 
	local txtObj 
	fn checkTextObject = 
		( 
		if $text01 == undefined then 
			( 
			txtObj = text text:"" name:"text01" 
			addModifier txtObj (extrude amount:10) 
			txtObj.wirecolor = red 
			rotate txtObj 90 x_axis 
			) 
		else ( txtObj = $text01 ) 
		) 
	activeXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" height:400 width:200 align:#left pos:[0,0]
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
		swf="E:\\02_Current_Jobs\\pondskata\\www.pondskata.com\\core\\interface08g.swf"
		axFlash.movie = swf
		axFlash.movie = swf
		checkTextObject(); 
		) 
	) 
/*
flashFloater = newRolloutFloater "Shockwave Flash Object" 350 300 10 10 
addRollout rFlash flashFloater 
*/
CreateDialog rFlash 350 200

/*
CreateDialog <Rollout>
<height>
<width>
<position_x>
<position_y>

pos:<Point2>
width:<integer>
height:<integer>

[bgcolor:<color>
fgcolor:<color> 
bitmap:<bitmap>
bmpstyle:<bmpstyle>
	
menu:<RCMenu>
style:<array>
modal:<boolean>
escapeEnable:<boolean>
lockHeight:<boolean>
lockWidth: <boolean>
*/