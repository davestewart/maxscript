var = attributes myCA
( 
	parameters main rollout:params 
	( 
		hitPoints type:#float --ui:hits default:10 
		cost type:#float --ui:cost default:100 
		sound type:#stringTab tabSizeVariable:true
	) 
	     
	rollout params "Weapon Parameters" 
	(
	)
) 
s=sphere selected:true
custAttributes.add $ var
$.baseobject.custAttributes[1].sound=#("cunt","dave")