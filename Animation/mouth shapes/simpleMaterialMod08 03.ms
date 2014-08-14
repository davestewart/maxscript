plugin modifier simpleMatMod
	name:"SimpleMaterialMod" 
	classID:#(0x79ce6e69, 0xa8933438) 
	extends:Materialmodifier replaceUI:true version:0.5
		(
		---------------------------------------------------------------------------------------------------
		-- init stuff
		---------------------------------------------------------------------------------------------------

		local params

		---------------------------------------------------------------------------------------------------

		parameters main rollout:params 
			( 
			matID type:#integer animatable:true ui:spn1
			on matID set val do
				(
				-- update buttons
					format "calling updateBtnStates with %\n" val
					params.updateBtnStates val
				-- update label text
					params.lblQuery3.text = val as string
				)
			) 
		rollout params "Material" 
			( 
			---------------------------------------------------------------------------------------------------
			-- Interface
			---------------------------------------------------------------------------------------------------

				checkButton ckb1 "1" width:32 height:32 checked:true enabled:false
				checkButton ckb2 "2" width:32 height:32
				checkButton ckb3 "3" width:32 height:32
				checkButton ckb4 "4" width:32 height:32

				button btnMat1 "Assign Random MultiMaterial" width:160 height:16 align:#left

				button btnQuery1 "Ctrl1" width:40 height:16 across:2 align:#left
				label lblQuery1 width:120 height:16 value:"test"

				button btnQuery2 "Ctrl2" width:40 height:16 across:2 align:#left
				label lblQuery2 width:120 height:16 value:"test"

				button btnQuery3 "matID?" width:40 height:16 across:2 align:#left
				label lblQuery3 width:120 height:16 value:"test"

				spinner spn1 type:#integer width:40 align:#left enabled: false

			---------------------------------------------------------------------------------------------------
			-- Variables
			---------------------------------------------------------------------------------------------------

				-- set controller for both subAnims
					local c = bezier_float()

			---------------------------------------------------------------------------------------------------
			-- Functions
			---------------------------------------------------------------------------------------------------
		

				fn updateBtnStates n =
					(
					format "updating button % state\n" n
					params.ckb1.state = n==1
					params.ckb2.state = n==2
					params.ckb3.state = n==3
					params.ckb4.state = n==4
					)


				fn updateID num=
					(
					-- set keys, even when animate is off, so that existing keys do not get disturbed
						with animate on matID = num

					-- set new keyframe tangents to step
						try(
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

				fn makeMaterial =
					(
					m = multimaterial numsubs:4
					for i = 1 to m.numsubs do m.material[i].diffuse = (color (random 0 255) (random 0 255)(random 0 255))
					$.material = m
					)
					
			---------------------------------------------------------------------------------------------------
			-- Handlers
			---------------------------------------------------------------------------------------------------
		
				-- set parameters
					on ckb1 changed state do updateID 1
					on ckb2 changed state do updateID 2
					on ckb3 changed state do updateID 3
					on ckb4 changed state do updateID 4


				-- check parameters (debug stuff)
					on btnQuery1 pressed do lblQuery1.text = delegate[1].controller as string
					on btnQuery2 pressed do lblQuery2.text = matID.controller as string

					on btnQuery3 pressed do lblQuery3.text = matID as string

					on spn1 changed val do lblQuery3.text = val as string

				-- make the controllers instance each other
					on params open do
						(
						delegate[1].controller = c
						matID.controller = c
						)
						
				-- tools
					on btnMat1 pressed do makeMaterial()
			) 
		) 
