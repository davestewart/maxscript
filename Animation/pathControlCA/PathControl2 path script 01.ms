-- add modifier
	addModifier $ (pathControl2())
	$.modifiers[#Path_Control_2].dist.controller = bezier_float()


-- setup position list
	if (classof $.position.controller != position_list) then
		(
		$.position.controller = (position_list())
		$.position.controller.available.controller=Path_Constraint()
		)
	
-- setup path controller
	$.position.controller["Path_Constraint"].percent.controller=float_script()
	$.position.controller["Path_Constraint"].percent.controller.script="local obj, refsArray, mod, path,dist,length
refsArray  = (refs.dependents this) 
for i in refsArray where isvalidnode i do obj = i.name
mod=(getNodeByName obj).modifiers[\"Path Control 2\"]
dependsOn mod

path=(getNodeByName obj).position.controller[\"Path_Constraint\"].path
if (path != undefined) then
	(
	length= amax (getSegLengths path 1)
	dist=mod.dist
	dist/length
	)
else 	0"
