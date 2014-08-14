try (destroydialog ro1); catch(err)
rollout ro1 "Timer animation test" width:162 height:50
	(
	timer tmr1 "Timer" pos:[8,112] width:24 height:24 interval:(1000 / 25)
	button btnClose "Close"
	
	local arrObj	= #()
	local animateObjects
	local v = 0
	local g = -5.0
	local f = 0.97
	local s, p
	local pv = 0, pzOld = 0
	
	fn mtCb msg ir obj faceNum shift ctrl alt =
		(
		mPos	= ir.pos
		animateObjects()
		#continue 
		)

	function setup =
		(
		-- delete Objects
			delete objects
			
		-- create objects
			s = sphere()
			p = plane()
			s.recenter = on
			s.pos.z = 100


		)
		
	function animateObjects =
		(
		-- plane
			
		-- sphere
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


