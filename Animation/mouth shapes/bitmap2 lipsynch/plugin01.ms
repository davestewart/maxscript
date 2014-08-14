plugin modifier simpleLipSync 
	name:"Simple Lip Sync" 
	classID:#(0x79ce6e65, 0xa8933438) 
	extends:Materialmodifier replaceUI:true version:1 
( 
		parameters main rollout:params 
		( 
			image type:#integer animateable:true
			frame type:#time animateable:true
		) 

		rollout params "Parameters" 
		( 
			---------------------------------------------------------------------------------------------------
			-- declare variables
			---------------------------------------------------------------------------------------------------
			
			local btnOld
			
			---------------------------------------------------------------------------------------------------
			-- Interface
			---------------------------------------------------------------------------------------------------
			local btnImage = getDir #scripts + "\\new\\mouth shapes\\img_i.bmp"
			local btnAlpha = getDir #scripts + "\\new\\mouth shapes\\img_a.bmp"
			local col = (color 0 255 0)
			
			GroupBox grp1 "Mouth Shapes" pos:[4,4] width:152 height:360
				checkbutton ckb0 "" pos:[8,24] width:32 height:32 images:#(btnImage, btnAlpha, 10, 1, 1, 1, 1) checked:true highlightColor: col
					label lbl0 "Rest" pos:[48,32] width:88 height:16
				checkbutton ckb1 "" pos:[8,64] width:32 height:32 images:#(btnImage, btnAlpha, 10, 2, 2, 2, 2) highlightColor: col
					label lbl1 "M B P" pos:[48,72] width:104 height:16
				checkbutton ckb2 "" pos:[8,96] width:32 height:32 images:#(btnImage, btnAlpha, 10, 3, 3, 3, 3) highlightColor: col
					label lbl2 "F V (D Th)" pos:[48,104] width:88 height:16
				checkbutton ckb3 "" pos:[8,128] width:32 height:32 images:#(btnImage, btnAlpha, 10, 4, 4, 4, 4) highlightColor: col
					label lbl3 "C D G K N R S Th Y Z" pos:[48,128] width:88 height:24
				checkbutton ckb4 "" pos:[8,160] width:32 height:32 images:#(btnImage, btnAlpha, 10, 5, 5, 5, 5) highlightColor: col
					label lbl4 "L (D Th)" pos:[48,168] width:88 height:16
				checkbutton ckb5 "" pos:[8,192] width:32 height:32 images:#(btnImage, btnAlpha, 10, 6, 6, 6, 6) highlightColor: col
					label lbl5 "W Q" pos:[48,200] width:88 height:16
				checkbutton ckb6 "" pos:[8,232] width:32 height:32 images:#(btnImage, btnAlpha, 10, 7, 7, 7, 7) highlightColor: col
					label lbl6 "U" pos:[48,240] width:88 height:16
				checkbutton ckb7 "" pos:[8,264] width:32 height:32 images:#(btnImage, btnAlpha, 10, 8, 8, 8, 8) highlightColor: col
					label lbl7 "O" pos:[48,272] width:88 height:16
				checkbutton ckb8 "" pos:[8,296] width:32 height:32 images:#(btnImage, btnAlpha, 10, 9, 9, 9, 9) highlightColor: col
					label lbl8 "A I" pos:[48,304] width:88 height:16
				checkbutton ckb9 "" pos:[8,328] width:32 height:32 images:#(btnImage, btnAlpha, 10, 10, 10, 10, 10) highlightColor: col
					label lbl9 "E" pos:[48,336] width:88 height:16
		
			---------------------------------------------------------------------------------------------------
			-- Functions
			---------------------------------------------------------------------------------------------------
		
				function btnChange btn mat state =
				(
					pushPrompt (($.modifiers[this.name][1][1].controller) as string)

				-- reset buttons
					btn.enabled = false
					btnOld.enabled = true
					btnOld.checked = false
					btnOld = btn

				-- set the parameters
					with animate on delegate.materialID = mat

				try(
				-- set keyframe info
					-- get controller
						c = $.modifiers[1][1][1].controller
					--get new key index
						kt = getKeyIndex c currentTime
					--get key as instance
						k = getKey c kt
					--set tangent types
						k.inTangentType = #step
						k.outTangentType = #step					
				)
				catch()
				)
		
		
			---------------------------------------------------------------------------------------------------
			-- Handlers
			---------------------------------------------------------------------------------------------------
		
				on ckb0 changed state do btnChange ckb0 1 state
				on ckb1 changed state do btnChange ckb1 2 state
				on ckb2 changed state do btnChange ckb2 3 state
				on ckb3 changed state do btnChange ckb3 4 state
				on ckb4 changed state do btnChange ckb4 5 state
				on ckb5 changed state do btnChange ckb5 6 state
				on ckb6 changed state do btnChange ckb6 7 state
				on ckb7 changed state do btnChange ckb7 8 state
				on ckb8 changed state do btnChange ckb8 9 state
				on ckb9 changed state do btnChange ckb9 10 state
		
				on params open do
				(
					btnOld = ckb0
				)
		) 
) 
