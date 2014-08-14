fn printObject obj=
(
	-- variables
		local nullSize=50
		local jsxStr=stringstream ""
	
	-- start
	if classof obj != Targetobject then
	(
		--format "Exporting %\n" obj.name
		format "var obj= new Object()\n" to: jsxStr

	-- object properties
		-- Plane, Rectangle
			if (classof obj.baseobject==Plane OR classof obj.baseobject==Rectangle) then
				format "	obj.properties={name:'%', parent:'%', aeClass:'Solid', width:%, height:%, color:%}\n" (getName obj) (getParentName obj) (obj.baseObject.width as integer) (obj.baseObject.length as integer) (getSolidColor obj) to:jsxStr
		
		-- Camera
			else if (superclassof obj.baseobject==Camera) then
				format "	obj.properties={name:'%', parent:'%', aeClass:'Camera', target:%}\n" (getName obj) (getParentName obj) (obj.target!=undefined) to:jsxStr
		
		-- Light
			else if (superclassof obj.baseobject==Light) then
				format "	obj.properties={name:'%', parent:'%', aeClass:'Light', target:%, lightType:'%'}\n" (getName obj) (getParentName obj) (obj.target!=undefined) (classof obj) to:jsxStr
		
		-- Text
			else if (classof obj.baseobject==text) then
				format "	obj.properties={name:'%', parent:'%', aeClass:'Text', text:'%'}\n" (getName obj) (getParentName obj) obj.baseObject.text to:jsxStr
		
		-- Null
			else 
				format "	obj.properties={name:'%', parent:'%', aeClass:'Null', width:%, height:%}\n" (getName obj) (getParentName obj) nullSize nullSize to:jsxStr
	

	-- animation
		-- transform
			-- position
				if true then format "	obj.position=%\n" (getKeyArray obj #position) to:jsxStr

			-- rotation
				if obj.target==undefined then format "	obj.orientation=%\n" (getKeyArray obj #rotation) to:jsxStr
				else format "	obj.orientation=%\n" (getKeyArray obj #roll) to:jsxStr
	
			-- scale
				if (superclassof obj != Camera AND superclassof obj != Light) then 
					format "	obj.scale=%\n" (getKeyArray obj #scale) to:jsxStr
			
			-- pivot
				if true then format "	obj.anchorPoint=%\n" (getKeyArray obj #pivot) to:jsxStr


		-- target
			if obj.target!=undefined then format "	obj.pointOfInterest=%\n" (getKeyArray obj.target #position) to:jsxStr
		
		-- camera
			if superclassof obj == Camera then format "	obj.Zoom=%\n" (getKeyArray obj #fov) to:jsxStr
		
		-- lights
			if superclassof obj == Light then
			(
				format "	obj.intensity=%\n" (getKeyArray obj #multiplier) to:jsxStr
				format "	obj.color=%\n" (getKeyArray obj #color) to:jsxStr
				if hasProperty obj "falloff" then
				(
					format "	obj.coneAngle=%\n" (getKeyArray obj #falloff) to:jsxStr
					format "	obj.coneFeather=%\n" (getKeyArray obj #hotspot) to:jsxStr
				)
			)


	-- end
		format "objArr.push(obj)\n\n" to: jsxStr
	)

		return (jsxStr as string)
	)