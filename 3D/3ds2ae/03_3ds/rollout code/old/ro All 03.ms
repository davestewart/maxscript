(
-----------------------------------------------------------------
-- setup

	clearListener()
	global max2ae=true
	try(destroyDialog max2ae);catch()

-----------------------------------------------------------------
-- main interface

	rollout max2ae "3dsmax > After Effects" width:450 height:400
	(
	-- includes

		include "core/utility.ms"


	-- variables
		local rootFolder="E:\\03_Scripting\\3ds2ae\\03_3ds\\rollout code\\"

	-- interface
		activeXControl ax "ShockwaveFlash.ShockwaveFlash.1" height:75 width:440  align:#center --pos:[8,8] 
		subrollout container "Rollouts" height:400 width:442 pos:[4,80]


	-- functions

		function flashClick n =
		(
			-- rollout information
				local numRollouts=container.rollouts.count
				local roHeights=for ro in container.rollouts collect ro.height

			-- variables
				if n>numRollouts then n=numRollouts

			-- rollout height
				local h=94
				for i = 1 to numRollouts do h+=20
				h+=roHeights[n]
				max2ae.height=h

			-- rollout open/close
				for i = 1 to numRollouts do container.rollouts[i].open=false
				container.rollouts[n].open=true
		)

	-- handlers
		-- flash
			on ax OnReadyStateChange n do format "handler: OnReadyStateChange : %\n" n 
			on ax OnProgress n do format "handler: OnProgress : %\n" n 
		
		-- handle flash click
			on ax FSCommand argName argVal do 
			(
				if argName == "click" then
				(
					setFocus ax
					n=argVal as Number
					flashClick n
				)
			) 
	
		-- load flash
			on max2ae open do 
			(
				local subRo=max2ae.controls[1]
				local f=(openfile "ui/flashUI.swf")
				local fStr
				if f!= undefined then
				(
					flush f; close f
			
					fStr=f as string
					fStr = substring fStr 7 (fStr.count-7)
					fStr=replaceAll fStr "\\" "/"
					
				)
				else messageBox "Interface file not found..."
	
				ax.movie = fStr
				ax.BackgroundColor=((colorMan.getColor #background)*255)as color
				ax.menu=false
			)

		-- resizing
			function resizeUI size=max2ae.container.height=size[2]-84

			on max2ae resized size do resizeUI size
			on max2ae opened do resizeUI size
			on max2ae close do max2ae=undefined
	)


-----------------------------------------------------------------
-- rollouts

	fileIn "ro setup 02.ms"
	fileIn "ro animation 06.ms"
	fileIn "ro render 02.ms"
	fileIn "ro effects 01.ms"
	fileIn "ro tools 01.ms"

-----------------------------------------------------------------
-- Build dialog
	
	createdialog max2ae 450 100 10 10 style:#(#style_titlebar,#style_resizing,#style_minimizebox,#style_sysmenu) lockWidth:true
	
	AddSubRollout max2ae.container roSetup-- rolledUp:false
	AddSubRollout max2ae.container roAnim rolledUp:true
	AddSubRollout max2ae.container roRend rolledUp:true
	AddSubRollout max2ae.container roEffects rolledUp:true
	AddSubRollout max2ae.container roTools rolledUp:true

	max2ae.flashClick 1
)
