-- layer methods
	(
	-- get layer names
	local layerNames=for i = 1 to layermanager.count collect (layermanager.getlayer (i-1)).name
	)



	(
	-- get object names in layer
	local n=0
	layer = layermanager.getlayer n
	layerRT = layer.layerAsRefTarg
	arr=for obj in refs.dependents layerRT where isvalidnode obj collect obj.name
	)
	



-- selection set methods
	(
	-- get selset names
	local selSetNames=for i in selectionsets collect i.name as string
	)

	(
	-- get object names in sel set
	n=1
	arr=for obj in refs.dependents layerRT where isvalidnode obj collect obj.name
	)

	(
	-- select sets
	select selectionsets["one"]
	select selectionsets[1]
	)
