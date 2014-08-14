plugin modifier simpleLipSync 
	name:"Simple Lip Sync" 
	classID:#(0x79ce6e65, 0xa8933438) 
	extends:Materialmodifier replaceUI:true version:1 
	( 
		parameters main rollout:params 
			( 
			--matID type:#integer animatable:true ui:bendamt default:1
			) 

		rollout params "Parameters" 
			( 
			---------------------------------------------------------------------------------------------------
			-- declare variables
			---------------------------------------------------------------------------------------------------
			local btnImage = getDir #scripts + "\\new\\mouth shapes\\mouths_i.bmp"
			local btnAlpha = getDir #scripts + "\\new\\mouth shapes\\mouths_a.bmp"
		
			---------------------------------------------------------------------------------------------------
			-- Interface
			---------------------------------------------------------------------------------------------------
			
			Group "Mouth Shapes"
				(
				button btn1 "" images:#(btnImage, btnAlpha, 12, 1 , 1 , 1 , 1)across:3 alighn:#left
				button btn2 "" images:#(btnImage, btnAlpha, 12, 2 , 2 , 2 , 2) 
				button btn3 "" images:#(btnImage, btnAlpha, 12, 3 , 3 , 3 , 3) 
				button btn4 "" images:#(btnImage, btnAlpha, 12, 4 , 4 , 4 , 4) across:3
				button btn5 "" images:#(btnImage, btnAlpha, 12, 5 , 5 , 5 , 5) 
				button btn6 "" images:#(btnImage, btnAlpha, 12, 6 , 6 , 6 , 6) 
				button btn7 "" images:#(btnImage, btnAlpha, 12, 7 , 7 , 7 , 7) across:4
				button btn8 "" images:#(btnImage, btnAlpha, 12, 8 , 8 , 8 , 8) 
				button btn9 "" images:#(btnImage, btnAlpha, 12, 9 , 9 , 9 , 9) 
				button btn10 "" images:#(btnImage, btnAlpha, 12, 10 , 10 , 10 , 10) 
				button btn11 "" images:#(btnImage, btnAlpha, 12, 11 , 11 , 11 , 11) across:2
				button btn12 "" images:#(btnImage, btnAlpha, 12, 12 , 12 , 12 , 12) 
				)
		
			---------------------------------------------------------------------------------------------------
			-- Functions
			---------------------------------------------------------------------------------------------------
		
				function setID mat =
					(
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
		
				on btn1 pressed do setID 1
				on btn2 pressed do setID 2
				on btn3 pressed do setID 3
				on btn4 pressed do setID 4
				on btn5 pressed do setID 5
				on btn6 pressed do setID 6
				on btn7 pressed do setID 7
				on btn8 pressed do setID 8
				on btn9 pressed do setID 9
				on btn10 pressed do setID 10
				on btn11 pressed do setID 11
				on btn12 pressed do setID 12
			) 
	) 
