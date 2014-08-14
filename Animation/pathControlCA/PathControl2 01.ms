plugin modifier pathControl2 
name:"Path Control 2" 
classID:#(0x21be5863, 0x154e3225) 
extends:NormalModifier
replaceUI:true version:1 
version:1.1
(
	
	parameters main rollout:params 
	( 
		dist type:#float ui:spnDist default:0 animatable:true 

	) 
	rollout params "Path Control Parameters" 
	( 
		spinner spnDist "Distance: " type:#float range:[0,10000,50] controller:(bezier_float())
	) 
	)