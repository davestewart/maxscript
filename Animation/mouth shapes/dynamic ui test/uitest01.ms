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
	
	-- images:#(
	-- 1: <image>,
	-- 2: <maskImage>
	-- 3: <count_integer>
	-- 4: <enabled_out_image_index>
	-- 5: <enabled_in_image_index>
	-- 6: <disabled_out_image_index>
	-- 7: <disabled_in_image_index>
	-- ) 


	Group "Mouth Shapes" 
	(
		checkbutton ckb0 "" pos:[8,24] width:32 height:32 images:#(btnImage, btnAlpha, 10, 1, 1, 1, 1) checked:true highlightColor: col
		label lbl0 "Rest" pos:[48,32] width:88 height:16
		edittext edt1 "w" text:(theBitMap.width as string) across:2
		edittext edt2 "h" text:(theBitMap.height as string)
	)



		local text1 = "Hello"

		Group "Lighting"
		(
			for i = 1 to 10 do
			(
				str1 = "checkButton ckb1 \"1\" width:32 height:32 align:#left across:2 checked:true enabled:false"
				str2 = "label lbl1 \"1.2.3.4.5.6.7.8.9.0.1.2.3.4.5.6.7.8.9\" width:105 offset:[-32,8] align:#left"
			execute str1
			execute str2
		)



	---------------------------------------------------------------------------------------------------
	-- Variables
	---------------------------------------------------------------------------------------------------
	
		-- initialize ckb1 as checked
			local btnOld = ckb1

		-- set controller for both subAnims
			local c = bezier_float()

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

