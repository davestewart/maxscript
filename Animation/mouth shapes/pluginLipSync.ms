plugin modifier simpleLipSync 
	name:"Simple Lip Sync" 
	classID:#(685325,452281) 
	extends:Bend replaceUI:true version:1 
	( 
		parameters main rollout:params 
		( 
			bendamt type:#float animatable:true ui:bendamt default:0.0 
			on bendamt set val do delegate.angle = val 
		) 
		rollout params "SupaCheka Parameters" 
		( 
			spinner bendamt "Bendiness: " 
		) 
	) 
