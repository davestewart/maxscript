rollout roPath "Path Control" width:168 height:32
(
-- variables
	local pathShape

-- interface
	button btnPath "Pick path..." pos:[8,8] width:152 height:16
	button btnAssign "Assign controller..." pos:[8,26] width:152 height:16

-- functions
	fn shapeFilt o = superClassOf o == Shape 

	fn assign obj=
	(
		-- setup custom attributes
			distCA = attributes Distance
			( 
				parameters main
				( 
					distance type:#float default:0 animateable:true
				) 
			)
		
		
		-- assign position list controller
			if (classof obj.position.controller != position_list) then
			(
				obj.position.controller = (position_list())
				obj.position.controller.available.controller=Path_Constraint()
			)
		
		-- assign CAs
			pathCtrl=obj.position.controller["Path_Constraint"]
			custAttributes.add  pathCtrl distCA
			pathCtrl.distance.controller=bezier_float()
			
		-- setup path controller
			obj.position.controller["Path_Constraint"].percent.controller=float_script()
			obj.position.controller["Path_Constraint"].percent.controller.script="obj=$'"+obj.name+"'
pathCtrl=obj.position.controller[#Path_Constraint]
dependsOn pathCtrl.distance.controller

if pathCtrl.path != undefined AND classof pathCtrl.path.baseobject == SplineShape then
(
	length= amax (getSegLengths pathCtrl.path 1)
	dist=pathCtrl.distance
	dist/length
)
else 0"
		if path!=undefined then obj.position.controller["Path_Constraint"].path=pathShape
	)
	
-- handlers
	on btnPath pressed do
	(
		local pathShape=pickObject prompt:"Pick a shape" filter:shapeFilt
		if path!=undefined then btnPath.text = pathShape.name
	)
	on btnAssign pressed do
	(
		if $!=undefined then for obj in $ do undo on (assign obj)
		else messagebox "You need a selection before running this script..."
	)

)
pathFloater = newRolloutFloater "Path" 174 90
addRollout roPath pathFloater
