---------------------------------------------------------------------------------------------------
-- declare variables
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------


rollout ro1 "Options" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------
	local x = 1


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	local btnImage = getDir #scripts + "\\new\\mouth shapes\\test_i.bmp"
	local btnAlpha = getDir #scripts + "\\new\\mouth shapes\\test_a.bmp"
	
	-- images:#(
	-- 1: <image>,
	-- 2: <maskImage>
	-- 3: <count_integer>
	-- 4: <enabled_out_image_index>
	-- 5: <enabled_in_image_index>
	-- 6: <disabled_out_image_index>
	-- 7: <disabled_in_image_index>
	-- ) 


	GroupBox grp1 "Dialogue" pos:[8,8] width:144 height:240
	
		checkbutton ckb1 "" pos:[16,24] width:32 height:24 images:#(btnImage, btnAlpha, 10, 1, 1, 1, 1)
			label lbl1 "A, I" pos:[56,28] width:88 height:16

		checkbutton ckb2 "" pos:[16,48] width:32 height:24 images:#(btnImage, btnAlpha, 10, 2, 2, 2, 2)
			label lbl2 "O" pos:[56,52] width:88 height:16

		checkbutton ckb3 "" pos:[16,72] width:32 height:24 images:#(btnImage, btnAlpha, 10, 3, 3, 3, 3)
			label lbl3 "E" pos:[56,76] width:88 height:16

		checkbutton ckb4 "" pos:[16,96] width:32 height:24 images:#(btnImage, btnAlpha, 10, 4, 4, 4, 4)
			label lbl4 "U" pos:[56,100] width:88 height:16

		checkbutton ckb5 "" pos:[16,120] width:32 height:24 images:#(btnImage, btnAlpha, 10, 5, 5, 5, 5)
			label lbl5 "C D G K N R S Th Y Z" pos:[56,124] width:88 height:16

		checkbutton ckb6 "" pos:[16,144] width:32 height:24 images:#(btnImage, btnAlpha, 10, 6, 6, 6, 6)
			label lbl6 "L (D Th)" pos:[56,148] width:88 height:16

		checkbutton ckb7 "" pos:[16,168] width:32 height:24 images:#(btnImage, btnAlpha, 10, 7, 7, 7, 7)
			label lbl7 "W Q" pos:[56,172] width:88 height:16

		checkbutton ckb8 "" pos:[16,192] width:32 height:24 images:#(btnImage, btnAlpha, 10, 8, 8, 8, 8)
			label lbl8 "M B P" pos:[56,196] width:88 height:16

		checkbutton ckb9 "" pos:[16,216] width:32 height:24 images:#(btnImage, btnAlpha, 10, 9, 9, 9, 9)
			label lbl9 "F V (D Th)" pos:[56,220] width:88 height:16


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
/*
images:#(<image>, <maskImage>, <count_integer>, \ 
<enabled_out_image_index>, <enabled_in_image_index>, \ 
<disabled_out_image_index>, <disabled_in_image_index>) 
*/

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------


)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater

