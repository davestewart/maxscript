MacroScript aeBridgeMcr category:"After Effects" tooltip:"After Effects Bridge"-- silentErrors:true
( 
	-----------------------------------------------------------------
	-- setup (macroscript scope)
		clearListener()
		try(destroyDialog aeBridge);catch()
		local SETTINGS	--local variable to directly access the roSettings rollout

	-- variables
		global aeBridge

		/*
		*/
		local appFolder=	"E:\\03_Scripting\\3ds2ae\\03_3ds\\rollout code\\"
		local appAE=		"C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"
		local iniFile=		appFolder+"\\core\\settings.ini"

--=true-- initialised so that the sub-rollouts don't create their own dialogs

	-----------------------------------------------------------------
	-- main interface

		rollout aeBridge "3dsmax > After Effects" width:422 height:496
		(
		-- includes
			include "core/utility.ms"
		
		-- interface
			ActiveXControl ax "ShockwaveFlash.ShockwaveFlash.1" pos:[0,0] width:424 height:88 --pos:[8,8] 
			subRollout container "Rollouts" pos:[4,88] width:412 height:400

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
					aeBridge.height=h
	
				-- rollout open/close
					for i = 1 to numRollouts do container.rollouts[i].open=false
					container.rollouts[n].open=true
					
				-- set title
					container.rollouts[1].setTitle (n!=1)
			)
	
		-- handlers

			-- load flash
				on aeBridge open do 
				(
					local subRo=aeBridge.controls[1]
					local f=(openfile "ui/flashUI2.swf")
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
					ax.BackgroundColor=((colorMan.getColor #background)*255		)as color
					ax.menu=false
				)
	
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
		
			-- resizing
				function resizeUI size=aeBridge.container.height=size[2]-84
	
				on aeBridge resized size do resizeUI size
				on aeBridge opened do resizeUI size
				on aeBridge close do aeBridge=undefined
		)
	
	
	-----------------------------------------------------------------
	-- rollouts
	
		include "ro settings 06.ms"
		include "ro animation 08.ms"
/*
		include "ro render 02.ms"
		include "ro effects 01.ms"
		include "ro tools 01.ms"
*/		
		SETTINGS=roSettings

	-----------------------------------------------------------------
	-- Build dialog
		
		createdialog aeBridge 420 100 10 10 style:#(#style_titlebar,#style_resizing,#style_minimizebox,#style_sysmenu) lockWidth:true							
		
		AddSubRollout aeBridge.container roSettings rolledUp:true
		AddSubRollout aeBridge.container roAnim rolledUp:false
/*
		AddSubRollout aeBridge.container roRend rolledUp:true
		AddSubRollout aeBridge.container roEffects rolledUp:true
		AddSubRollout aeBridge.container roTools rolledUp:true
*/	
		--aeBridge.flashClick 2
) 

macros.run "After Effects" "aeBridgeMcr"

show aeBridge.controls[2]

SETTINGS

aeBridge