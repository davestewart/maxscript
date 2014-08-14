rollout roPath "Path Control" width:168 height:32
(

-- interface
	button btn1 "Assign path controller..." pos:[8,8] width:152 height:16

-- functions
	fn assign obj=
		(
		-- setup custom attributes
			distCA = attributes Path_Attributes
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
			obj.position.controller["Path_Constraint"].percent.controller.script="local dist,length
		
obj=$'"+obj.name+"'
pathCtrl=obj.position.controller[#Path_Constraint]
dependsOn pathCtrl.distance.controller

if pathCtrl.path != undefined AND classof pathCtrl.path.baseobject == SplineShape then
	(
	length= amax (getSegLengths pathCtrl.path 1)
	dist=pathCtrl.distance
	dist/length
	)
else 0"
		)
	
-- handlers
	on btn1 pressed do
		(
		if $!=undefined then for obj in $ do assign obj
		else messagebox "You need a selection before running this script..."
		)

)
pathFloater = newRolloutFloater "Path" 174 60
addRollout roPath pathFloater
