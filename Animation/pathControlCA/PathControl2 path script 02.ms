-- setup custom attributes
	distCA = attributes Custom_Attributes
	( 
		parameters main
		( 
			distance type:#float default:0 animateable:true
		) 
	)


-- assign position list controller
	if (classof $.position.controller != position_list) then
	(
		$.position.controller = (position_list())
		$.position.controller.available.controller=Path_Constraint()
	)


-- assign CAs
	pathCtrl=$.position.controller["Path_Constraint"]
	custAttributes.add  pathCtrl distCA
	pathCtrl.distance.controller=bezier_float()
	

	
-- setup path controller
	$.position.controller["Path_Constraint"].percent.controller=float_script()
	$.position.controller["Path_Constraint"].percent.controller.script="local obj, refsArray, mod, path,dist,length

for i in (refs.dependents this) where isvalidnode i do obj = i.name
pathCtrl=(getNodeByName obj).position.controller[\"Path_Constraint\"]
dependsOn pathCtrl.distance.controller

path=(getNodeByName obj).position.controller[\"Path_Constraint\"].path
if (path != undefined) then
(
	length= amax (getSegLengths path 1)
	dist=pathCtrl.distance
	dist/length
)
else 	0"
