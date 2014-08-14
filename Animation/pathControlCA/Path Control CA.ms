distCA = attributes Custom_Attributes
( 
	parameters main
	( 
		distance type:#float default:0 animateable:true
	) 
) 

pathCtrl=$.position.controller["Path_Constraint"]
custAttributes.add  pathCtrl distCA
pathCtrl.distance.controller=bezier_float()