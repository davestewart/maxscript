plugin modifier simpleLipSync 
	name:"Simple Lip Sync" 
	classID:#(0x79ce6e65, 0xa8933438) 
	extends:Materialmodifier replaceUI:true version:1 
	( 
		parameters main rollout:params 
			( 
			matID type:#integer animatable:true ui:spnMatID default:1

			on matID get val do
				(
				label.text = ("> " + val as string)
				)
			) 

		rollout params "Parameters" 
			( 
			---------------------------------------------------------------------------------------------------
			-- declare variables
			---------------------------------------------------------------------------------------------------

			-- button change stuff
				local btnOld
			
			---------------------------------------------------------------------------------------------------
			-- Interface
			---------------------------------------------------------------------------------------------------
			local btnImage = getDir #scripts + "\\new\\mouth shapes\\mouths_i.bmp"
			local btnAlpha = getDir #scripts + "\\new\\mouth shapes\\mouths_a.bmp"
			local col = (color 0 255 0)
			
			Group "Mouth Shapes"
				(
				checkbutton ckb1 "" images:#(btnImage, btnAlpha, 12, 1 , 1 , 1 , 1) checked:true across:3 alighn:#left
				checkbutton ckb2 "" images:#(btnImage, btnAlpha, 12, 2 , 2 , 2 , 2) 
				checkbutton ckb3 "" images:#(btnImage, btnAlpha, 12, 3 , 3 , 3 , 3) 
				checkbutton ckb4 "" images:#(btnImage, btnAlpha, 12, 4 , 4 , 4 , 4) across:3
				checkbutton ckb5 "" images:#(btnImage, btnAlpha, 12, 5 , 5 , 5 , 5) 
				checkbutton ckb6 "" images:#(btnImage, btnAlpha, 12, 6 , 6 , 6 , 6) 
				checkbutton ckb7 "" images:#(btnImage, btnAlpha, 12, 7 , 7 , 7 , 7) across:4
				checkbutton ckb8 "" images:#(btnImage, btnAlpha, 12, 8 , 8 , 8 , 8) 
				checkbutton ckb9 "" images:#(btnImage, btnAlpha, 12, 9 , 9 , 9 , 9) 
				checkbutton ckb10 "" images:#(btnImage, btnAlpha, 12, 10 , 10 , 10 , 10) 
				checkbutton ckb11 "" images:#(btnImage, btnAlpha, 12, 11 , 11 , 11 , 11) across:2
				checkbutton ckb12 "" images:#(btnImage, btnAlpha, 12, 12 , 12 , 12 , 12) 
				spinner spnMatID "" width:31 height:16
				label lbl1 ">" width:100 height:20
				)
		
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
						c = delegate.materialID.controller
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
		
				on ckb1 changed state do btnChange ckb1 1 state
				on ckb2 changed state do btnChange ckb2 2 state
				on ckb3 changed state do btnChange ckb3 3 state
				on ckb4 changed state do btnChange ckb4 4 state
				on ckb5 changed state do btnChange ckb5 5 state
				on ckb6 changed state do btnChange ckb6 6 state
				on ckb7 changed state do btnChange ckb7 7 state
				on ckb8 changed state do btnChange ckb8 8 state
				on ckb9 changed state do btnChange ckb9 9 state
				on ckb10 changed state do btnChange ckb9 10 state
				on ckb11 changed state do btnChange ckb9 11 state
				on ckb12 changed state do btnChange ckb9 12 state
		
				on params open do
					(
					btnOld = ckb1
					)

			) 
	) 
