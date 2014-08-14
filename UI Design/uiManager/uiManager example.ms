-------------------------------------------------------------------------------------------------------------------------------
-- 
-- UI Manager Example
-- Load and save position when a dialog opens and closes
-- 
-------------------------------------------------------------------------------------------------------------------------------

rollout roTools "Tools" width:100 height:50
	(
	-- interface
		spinner spn1 "Start" range:[1,100,20] type:#integer fieldwidth:30 align:#right
		spinner spn2 "End" range:[1,100,80] type:#integer fieldwidth:30 align:#right

	-- reference to the local UI Manager
		local ui

	-- handlers
		on roTools open do
			(
			-- initialize the UI manager upon on opening the rollout
			-- this will create a file named after the rollout (Tools.ini) if it doesn't exist
			-- or will simply reference the file if it does exist
				ui = uiManager()
				ui.initialize roTools
				
			-- load all previously saved values
				ui.loadAllValues()
				
			-- load previously saved position
				ui.loadPosition()
			)
			
		on roTools close do
			(
			-- save all control values
				ui.saveAllValues()
				
			-- save rollout position
				ui.savePosition()
			)
			
	-- handlers	
		-- this spinner pair are instructed to update when each other's vales are changed.
		-- this is useful for low and high values, such as frame ranges
			on spn1 changed val do ui.updateSpinnerPair spn1 spn2 1
			on spn2 changed val do ui.updateSpinnerPair spn1 spn2 2
	
	)

createdialog roTools
