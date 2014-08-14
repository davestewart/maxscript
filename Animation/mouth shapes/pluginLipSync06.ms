plugin modifier simpleLipSync 
	name:"Simple Lip Sync" 
	classID:#(0x79ce6e65, 0xa8933438) 
	extends:Materialmodifier replaceUI:true version:1 
	( 
		local params


		parameters main rollout:params 
		( 
			matID type:#integer animatable:true ui:spn1 default:1
			spn2Val type:#integer animatable:true ui:spn2 default:1

			on matID set val do
			(
				delegate.materialID = val
				params.lbl1.text = val as string
			)

			on material_ID get val do (pushprompt (val as string))

		) 
		rollout params "Spinner Anim Test" 
		( 
			spinner spn1 "Spinner1: " range:[1,10,1] type:#integer
			spinner spn2 "Spinner 2: " range:[1,10,1] type:#integer
			label lbl1 width:100 height:16 align:#right

			on spn1 changed val do params.lbl1.text = val as string

		) 
	) 
