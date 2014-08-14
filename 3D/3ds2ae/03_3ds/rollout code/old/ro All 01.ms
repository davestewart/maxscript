-----------------------------------------------------------------
-- functions

	if max2aeFloater!=undefined then closerolloutfloater max2aeFloater
	max2aeFloater = newRolloutFloater "3ds2ae" 450 350 10 10 

-----------------------------------------------------------------
-- functions

	fileIn "core\\utility.ms"
	
-----------------------------------------------------------------
-- rollouts
	fileIn "settings\\ro settings 02.ms"
	fileIn "animation\\ro animation 06.ms"
	fileIn "render\\ro render 02.ms"
	fileIn "effects\\ro effects 01.ms"
	fileIn "tools\\ro tools 01.ms"

rollout rFlash "Interface" 
	( 

-- variables
	local rollouts=#(roSettings,roAnim,roRend,roEffects,roTools)
	local roCurrent

-- interface
	activeXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" height:75 width:401 align:#left 

-- handlers
	-- flash
		on axFlash OnReadyStateChange arg1 do format "handler: OnReadyStateChange : %\n" arg1 
		on axFlash OnProgress arg1 do format "handler: OnProgress : %\n" arg1 
	
		on axFlash FSCommand arg1 arg2 do 
			(
			-- messagebox
				--rFlash.title=(arg1 + " " +arg2)
				--messagebox (arg1 + " " +arg2)
				setFocus axFlash
			-- rollout open/close
				/*
				for r in rollouts do r.open=false
				execute("ro"+arg1 as string+".open=true")
				*/
			--roCurrent=execute("ro"+arg1 as string)
			--addRollout roCurrent max2aeFloater
			for i = 2 to 6 do max2aeFloater.rollouts[i].open=false
			max2aeFloater.rollouts[(arg1 as Number)+1].open=true

			) 
	
		on rFlash open do 
			(
			local f=(openfile "flashUI.swf")
			local fStr
			if f!= undefined then
				(
				flush f; close f
		
				fStr=f as string
				fStr = substring fStr 7 (fStr.count-7)
				fStr=replaceAll fStr "\\" "/"
				
				)
			else messageBox "Interface file not found..."

			axFlash.movie = fStr--path+file 
			axFlash.BackgroundColor=((colorMan.getColor #background)*255)as color
			axFlash.menu=false
			)


	) 

addRollout rFlash max2aeFloater
addRollout roSettings max2aeFloater rolledUp:false
addRollout roAnim max2aeFloater rolledUp:true
addRollout roRend max2aeFloater rolledUp:true
addRollout roEffects max2aeFloater rolledUp:true
addRollout roTools max2aeFloater rolledUp:true

show max2aeFloater

createdialog roTools

rotools.height=300
