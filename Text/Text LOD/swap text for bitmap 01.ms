function replaceTextWithMap obj =
	(
	-- get text
		local t = obj
		local size = t.max - t.min
	
	-- create camera
		local c = freecamera transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] t.center) isSelected:true
	
	-- get distance to move
		--tan a = y / x
		--tan a * x = y
		-- x = y / tan a
		
		local w = size[1]
		local h = size[3]
		
		local y = w / 2
		local a = c.fov / 2
		local x = y / (tan a)
	
	-- move
		c.pos.y = t.pos.y - x
		
	-- render
	
		local savepath = "E:/02_Current_Jobs/2006-06 - LittleFire, Borders Conference/2 - 3d/maps/text/" + t.name + ".tga"
		select t
		
		local bgColor = backgroundColor
		backgroundColor = black
		local outputSize = [w,h]*2
		render camera:c outputSize:outputSize outputfile:savepath renderType:#selected vfb:false
		backgroundColor = bgColor 
	
	-- replace
		-- material
			if t.material == undefined then t.material = standardmaterial()
			local m = standardmaterial diffuse:t.material.diffuse opacity:t.material.opacity opacityMap:(Bitmaptexture fileName:savepath)
			m.opacityMap.monoOutput = 1
			m.name = t.name
			showTextureMap m true
	
		-- plane	
			local p = plane width:w length:h widthsegs:1 lengthsegs:1 material:m transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] t.center) isSelected:true
			t.parent = p
			p.name = t.name + " (plane)"
	
	-- clean up
		--hide t
		delete c
		select #(t,p)
	)

arr = $'Bg text'* as array
--for obj in arr do replaceTextWithMap obj

replaceTextWithMap $