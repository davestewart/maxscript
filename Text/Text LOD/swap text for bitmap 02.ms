function replaceTextWithMap sel =
(

	local savePath = "E:/02_Current_Jobs/2006-06 - LittleFire, Borders Conference/2 - 3d/maps/text/"

	if sel == undefined then
	(
		messagebox "Nothing selected!"
		return false
	)
	if classof sel == ObjectSet then
	(
		sel = sel as array
		obj = sel[1]
	)
	else
	(
		obj = sel
	)
	
	-- get text
		local t		= obj
		local size	= t.max - t.min
	
	-- get distances
		--tan a = y / x
		--tan a * x = y
		-- x = y / tan a
		
		-- trig
			local x, y, a
			local w		= size[1]
			local h		= size[3]
	
		-- camera
			local ortho = true
			
		
		-- workings
			if NOT ortho then
			(
				fov		= 45
				a		= fov / 2
				y		= w / 2
				x		= y / (tan a)
			)
			else
			(
				fov		= 90
				y		= w / 2
				x		= if h > w then (h / (h/w) / 2) else w / 2
			)
				
		
	-- create camera
		local c				= freecamera transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] t.center) isSelected:false fov:fov


		c.pos.y				= t.pos.y - x
		c.orthoProjection	= ortho
		c.baseobject.targetDistance = x


	-- render
	
		savepath			+= t.name + ".tga"
		
		select sel

		local vfb			= false
		local bgColor		= backgroundColor
		backgroundColor		= black
		local outputSize	= [w,h]*2
	
		render camera:c outputSize:outputSize outputfile:savepath renderType:#selected vfb:vfb

		backgroundColor		= bgColor
	
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
/*	
*/
)

--arr = $'Bg text'* as array
--for obj in arr do replaceTextWithMap obj

replaceTextWithMap $


