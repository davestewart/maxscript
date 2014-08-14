plugin simpleMod saddle
name:"SaddleDeform"
classID:#(685325,452281)
version:1
	( 
	parameters main rollout:params
		(
		amount type:#float ui:amtSpin default:20
		radius type:#float ui:amtRadius default:22.5
		deform type:#integer ui:rdoDeform default:1
		)
	rollout params "Saddle Parameters"
		(
		spinner amtSpin "Amount: " type:#float range:[0,1000,20]
		spinner amtRadius "Radius: " type:#float range:[1,1000,22.5]
		radioButtons rdoDeform "Type" labels:#("sin", "cos", "tan") default:1
		)
	on map i p do
		(
		case deform of
			(
			1: p.z += amount * sin((p.x * radius/extent.x) * (p.y * radius/extent.y))
			2: p.z += amount * cos((p.x * radius/extent.x) * (p.y * radius/extent.y))
			3: p.z += amount * tan((p.x * radius/extent.x) * (p.y * radius/extent.y))
			)
		p
		)
	)


