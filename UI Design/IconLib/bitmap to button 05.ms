rollout roIconLibrary "Icon Library" width:128 height:256
(
	---------------------------------------------------------------------------------------------
	-- iconUtil include
	---------------------------------------------------------------------------------------------
	
		include "iconUtils.ms"
	
	---------------------------------------------------------------------------------------------
	-- interface
	---------------------------------------------------------------------------------------------

		button btn1 "?" pos:[56,32] width:16 height:16
		button btn2 "?" pos:[33,8] width:16 height:16
		button btn3 "?" pos:[56,8] width:16 height:16
		button btn4 "?" pos:[8,8] width:16 height:16
		button btn5 "?" pos:[32,56] width:16 height:16
		button btn6 "?" pos:[56,56] width:16 height:16
		button btn7 "?" pos:[8,56] width:16 height:16
		button btn8 "?" pos:[8,32] width:16 height:16
		button btn9 "?" pos:[32,104] width:16 height:16
		button btn10 "?" pos:[8,152] width:16 height:16
		button btn11 "?" pos:[32,152] width:16 height:16
		button btn12 "?" pos:[56,152] width:16 height:16
		button btn13 "?" pos:[56,200] width:16 height:16
		button btn14 "?" pos:[8,128] width:16 height:16
		button btn15 "?" pos:[8,104] width:16 height:16
		button btn17 "?" pos:[8,176] width:16 height:16
		button btn18 "?" pos:[32,176] width:16 height:16
		button btn19 "?" pos:[56,176] width:16 height:16
		button btn20 "?" pos:[8,200] width:16 height:16
		button btn21 "?" pos:[32,200] width:16 height:16
		button btn61 "?" pos:[32,128] width:16 height:16
		button btnAssignRandomIcons "Assign Random Icons" pos:[8,232] width:112 height:16
	
	---------------------------------------------------------------------------------------------
	-- icon names
	---------------------------------------------------------------------------------------------


		-- grab the icon names (unordered)
			local iconNames = iconUtils.getIconNames()
			
		-- actually, I prefer them ordered
			local iconNames = #("arrowE", "arrowN", "arrowNE", "arrowNW", "arrowS", "arrowSE", "arrowSW", "arrowW", "cross", "dotBig", "dotMed", "dotSmall", "dialog", "refresh", "tick","copy","cut","paste","open","save","refreshBold")

	---------------------------------------------------------------------------------------------
	-- handlers
	---------------------------------------------------------------------------------------------

		on roIconLibrary open do
		(
			-- default variables
				local fg	= colorMan.getColor #text as color
				local bg	= colorMan.getColor #background as color
			
			-- loop through controls and assign button image
				for i = 1 to iconNames.count do
				(
					-- grab control
						local icon	= iconNames[i]
						local btn	= roIconLibrary.controls[i]
						
					-- assign icon
						iconUtils.setButtonIcon btn icon
			
				)
		)
			
		on btnAssignRandomIcons pressed do
		(
			for i = 1 to roIconLibrary.controls.count - 1 do
			(
				local fg	= random black white
				local bg	= random black white
				local icon	= iconNames[random 1 iconNames.count]
				local btn	= roIconLibrary.controls[i]
				
				iconUtils.setButtonIcon btn icon fg:fg bg:bg
			)
		)
)
createdialog roIconLibrary
