plugin modifier simpleMatMod
	name:"SimpleMaterialMod" 
	classID:#(0x79ce6e69, 0xa8933438) 
	extends:Materialmodifier replaceUI:true version:1 
	( 
		parameters main rollout:params 
		( 
			matID type:#integer animatable:true
			on matID set val do delegate.materialID = val 
		) 
		rollout params "Material" 
		( 
			---------------------------------------------------------------------------------------------------
			-- Interface
			---------------------------------------------------------------------------------------------------

				checkButton ckb1 "CheckButton" width:32 height:32
				checkButton ckb2 "CheckButton" width:32 height:32

			---------------------------------------------------------------------------------------------------
			-- Functions
			---------------------------------------------------------------------------------------------------
		
				function btnChange btn mat state =
				(
					--pushPrompt (($.modifiers[this.name][1][1].controller) as string)

				-- reset buttons
					btn.enabled = false
					btnOld.enabled = true
					btnOld.checked = false
					btnOld = btn

				-- set the parameters
					with animate on delegate.materialID = mat
			---------------------------------------------------------------------------------------------------
			-- Handlers
			---------------------------------------------------------------------------------------------------
		
				on ckb0 changed state do btnChange ckb0 1 state
				on ckb1 changed state do btnChange ckb1 2 state

		) 
	) 
