try (destroydialog ro1); catch(err)
rollout ro1 "Timer animation test" width:162 height:50
	(
	timer tmr1 "Timer" pos:[8,112] width:24 height:24 interval:(1000 / 25)
	button btnClose "Close"
	
	local animateObjects
	local v = 0
	local g = -5.0
	local f = 0.97
	local p, c, d, s
	
	fn moveToSurface src trg =
		( 
		r1	= ray (src.pos + [0,0,10000]) [0,0,-1] 
		r2	= intersectRay trg r1
		z	= if r2 == undefined then 0 else r2.pos.z
		src.pos.z = z
		)
	

	function setup =
		(
		-- delete Objects
			delete objects
			
		-- create objects
			p = plane width:1000 length:1000 widthsegs:50 lengthsegs:50 isselected:true
			addmodifier p (noisemodifier strength:[0,0,50])
			c = circle radius:400 pos:[0,0,100]
			
			d = dummy()
			local pc = Path_Constraint ()
			d.pos.controller = pc
			pc.appendTarget c 100
			
			s = sphere()
			s.recenter = on
		)
		
	function animateObjects =
		(
		-- sphere horz
			s.pos.x = d.pos.x
			s.pos.y = d.pos.y

		-- sphere vert
		
			moveToSurface s p
		/*
			v += g + ( pv / 5)
			s.pos.z += v
			if s.pos.z < p.pos.z then
				(
				
				--pv = pzOld - p.pos.z
				--pzOld = p.pos.z
				
				v = -v
				v *= f
				s.pos.z = p.pos.z
				)
			--else pv = 0
				*/
		)
		
	function cleanup = 
		(
		tmr1.active = false
		try(
			for obj in arrObj do delete obj
			)
		catch(err)
		)
	
	on ro1 open do setup()
	
	on ro1 close do cleanup()
	
	on btnClose pressed do
		(
		destroydialog ro1
		)
	
	on tmr1 tick  do
		(
		animateObjects ()
		)
	)

createdialog ro1


