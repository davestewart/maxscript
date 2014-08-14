-- custom attributes
	if distanceCA == undefined then
		(
		distanceCA = attributes "Distance" (
			)
		)

	distanceCA = attributes "Distance" redefine:distanceCA
		(
		parameters main rollout:params
			(
			Value type:#float ui:spnValue default:0
			)
		 
		rollout params "Distance"
			(
			spinner spnValue "Value: " type:#float range:[0,999999,0]
			)
		)

function createObjects =
	(
	-- setup objects
		obj = sphere()
	
		ln = splineshape()
		addNewSpline ln
		addKnot ln 1 #smooth #curve [0,0,0]
		addKnot ln 1 #smooth #curve [-100,0,0]
		addKnot ln 1 #smooth #curve [-100,100,0]
		addKnot ln 1 #smooth #curve [0,100,0]
		close ln 1
		updateshape ln
		
	)


function applyPathController obj ln =
	(
	-- vars
		local pc, lc, sc, bc
	
	-- path controller
		pc = obj.position.controller = path_constraint()
		pc.appendTarget ln 100
	
	-- scripted percent
		lc = pc.percent.controller = float_list()
		bc = lc[1].controller = bezier_float()
		sc = lc[2].controller = float_script()
		lc.setName 1 "Distance"
		lc.setName 2 "Script"
		lc.weight = #(0,100)
		
		for i = 1 to lc.weights.numSubs do
			(
			lc.weights[i].controller = bezier_float()
			lc.weights[i].controller.keyable = false
			)
		
		lc.active = 1

	-- setup script controller
		sc.AddNode "path" ln
		sc.AddObject "distance" bc
		sc.script	= "dist	= distance.value\n"
		sc.script	+="length	= amax (getSegLengths path 1)\n"
		sc.script	+= "dist/length * 100\n"
		sc.update()
	)


function addDistanceSpinner obj wire:false =
	(
	-- add modifier and ca
		if classof obj.modifiers[1] != EmptyModifier then addModifier obj (EmptyModifier name:"Path Control")
		custAttributes.add obj.modifiers[1] distanceCA
		obj.modifiers[1].value.controller = bezier_float()
	-- wire
		if wire then
			(
			paramWire.connect2Way \
				obj.position.controller.percent.controller[1] \
				obj.modifiers[1].distance[1] \
				"value / 100" \
				"Distance * 100"
			)
	-- edit keys
		
	)

/*
paramWire.connect \
	obj.modifiers[1].distance[1] \
	obj.position.controller.percent.controller[1] \
	"distance / 100"
*/


createObjects()
applyPathController $sphere01 $shape01 
addDistanceSpinner $sphere01 wire:true

/*
obj.position.controller.percent.controller[1]
obj.modifiers[1].value.controller = bezier_float()
*/
/*
$.position.controller.percent.controller[1].controller.Distance_Animation.controller.keys

$.position.controller.percent.controller.weights[1].controller.keyable = false
$.position.controller.percent.controller.weights[2].controller.keyable = false
.weights
keyable 
iskeyable
*/