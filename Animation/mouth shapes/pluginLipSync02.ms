plugin modifier simpleLipSync 
	name:"Simple Lip Sync" 
	classID:#(0x79ce6e65, 0xa8933438) 
	extends:Materialmodifier replaceUI:true version:1 
( 
		parameters main rollout:params 
		( 
			matID type:#integer animatable:true ui:bendamt default:1
			on matID set val do delegate.materialID = val 
		) 

		rollout params "SupaCheka Parameters" 
		( 
			spinner bendamt "Bendiness: "
			radioButtons matID "RadioButtons" pos:[8,8] width:35 height:62 labels:#(1, 2, 3)
		) 
) 
