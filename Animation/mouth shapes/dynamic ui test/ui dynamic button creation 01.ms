---------------------------------------------------------------------------------------------------
-- declare variables
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------


rollout ro1 "Options" width:160 height:311
	( 
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
		local btnImage = getDir #scripts + "\\new\\mouth shapes\\img_i.bmp"
		local btnAlpha = getDir #scripts + "\\new\\mouth shapes\\img_a.bmp"
		local col = (color 0 255 0)
		
		local theBitMap = openBitMap btnImage
		
		Group "Debug"
			(
			edittext edt1 "w" text:(theBitMap.width as string) across:2
			edittext edt2 "h" text:(theBitMap.height as string)
			)
			
		Group "Mouth Shapes" 
			(
			checkbutton ckb0 ""  width:32 height:32 images:#(btnImage, btnAlpha, 10, 1, 1, 1, 1) checked:true highlightColor: col across:2
			label lbl0 "Rest" width:88 height:16
			--label blank1 "Rest" height:1
			checkbutton ckb1 ""  width:32 height:32 images:#(btnImage, btnAlpha, 10, 1, 1, 1, 1) checked:true highlightColor: col offset:[0,-5]across:2
			label lbl1 "Rest" width:88 height:16
			label blank2 "Rest" height:1
			)






	---------------------------------------------------------------------------------------------------
	-- Variables
	---------------------------------------------------------------------------------------------------
	

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

			
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater

