clearListener()
-----------------------------------------------------------------
-- rollouts

	rollout roFlash "Control Panel"
	( 

	-- includes

		include "core/utility.ms"


	-- variables
		global roSettings,roAnim,roRend,roEffects,roTools
		local rollouts=#(roSettings,roAnim,roRend,roEffects,roTools)
		local roCurrent
		local roHeights
		local subRo=max2aefloater.controls[1]

	
	-- interface
		activeXControl ax "{D27CDB6E-AE6D-11CF-96B8-444553540000}" height:75 width:401 align:#left 

	
	-- functions

		function flashClick n =
		(
			-- rollout information
				local numRollouts=subRo.rollouts.count
				roHeights=for ro in subRo.rollouts collect ro.height

			-- variables
				if n>numRollouts then n=numRollouts

			-- rollout height
				local h=roHeights[1]+20+25
				for i = 2 to n do h+=20
				h+=roHeights[n]
				max2aeFloater.height=h

			-- rollout open/close
				for i = 2 to numRollouts do subRo.rollouts[i].open=false
				subRo.rollouts[n].open=true
		)

	-- handlers
		-- flash
			on ax OnReadyStateChange n do format "handler: OnReadyStateChange : %\n" n 
			on ax OnProgress n do format "handler: OnProgress : %\n" n 
		
			on ax FSCommand n arg2 do 
			(
				setFocus ax
				n=n as Number
				flashClick n
			) 
		
			on roFlash open do 
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
	
				ax.movie = fStr--path+file 
				ax.BackgroundColor=((colorMan.getColor #background)*255)as color
				ax.menu=false
			)
	)

	fileIn "settings/ro settings 02.ms"
/*
	fileIn "animation/ro animation 06.ms"
	fileIn "render/ro render 02.ms"
	fileIn "effects/ro effects 01.ms"
	fileIn "tools/ro tools 01.ms"
*/

-----------------------------------------------------------------
-- Build dialog
	
	destroyDialog max2aeFloater
	rollout max2aeFloater "3ds2ae" width:450 height:400
	(
		subrollout container "Rollouts" height:400
		on max2aeFloater resized size do max2aeFloater.container.height=size[2]-10
	) 

	createdialog max2aeFloater 450 128 10 10 style:#(#style_titlebar,#style_resizing,#style_minimizebox,#style_sysmenu) lockWidth:true
	
	AddSubRollout max2aeFloater.container roFlash
	AddSubRollout max2aeFloater.container roSettings-- rolledUp:false
/*
	AddSubRollout max2aeFloater.container roAnim rolledUp:true
	AddSubRollout max2aeFloater.container roRend rolledUp:true
	AddSubRollout max2aeFloater.container roEffects rolledUp:true
	AddSubRollout max2aeFloater.container roTools rolledUp:true
*/
	roFlash.flashClick 2
