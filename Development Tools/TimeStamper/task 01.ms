
-- test 1	
	b = box()
	s = sphere()
	pos = for i = 1 to 5000 collect (random [-100,-100,-100] [100,100,100] )
	converttomesh b
	
	t1 = TimeStamper("Attach Test - all")
	t2 = TimeStamper("Attach Test - processes")
	
	t1.start()
	with undo off with redraw off
	(
		for i = 1 to pos.count do
		(
				t2.start()
				s.pos = pos[i]
				meshop.attach b s deleteSourceNode:false
				append arr (t2.end())
		)
	)
	
	t1.print()
	for i = 1 to 5000 by 100 do
	(
		format "Processing attach % - % seconds\n" (i as string)  (t2.durations[i] as string)
	)
	
	
-- test 2

	-- variables
		total		= 1000
		iterations	= 50

	-- variables
		s = sphere()
		pos = for i = 1 to total collect (random [-100,-100,-100] [100,100,100] )
		meshes = #()
		
	-- time stampers
		t1 = TimeStamper("Attach Test - all")
		t2 = TimeStamper("Attach Test - create sphere groups")
		t3 = TimeStamper("Attach Test - attach sphere groups")
		
	-- main loop
		t1.start()
		with undo off with redraw off
		(
			
		-- create sphere groups loop
			for i = 1 to pos.count / iterations do
			(
				t2.start()
				b = box()
				converttomesh b
				
			-- create spheres loop
				for j = 1 to iterations do
				(
					index = ((i - 1)* iterations) + j
					s.pos = pos[index]
					meshop.attach b s deleteSourceNode:false
				)
				append meshes b
				t2.print()
			)
		)
		
		
	-- attach sphere groups loop
		t3.start()
		for i = 2 to meshes.count do
		(
			meshop.attach meshes[1] meshes[i]
		)
		t3.print()
	
	-- stats
		t1.print()
/*
	for i = 1 to 5000 by 100 do
	(
		format "Processing attach % - % seconds\n" (i as string)  (t2.durations[i] as string)
	)
	*/
-- Processing 'Attach Test - all' took 3.687 seconds.
