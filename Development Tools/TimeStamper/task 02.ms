
-- test 1	
	function createSpheresOld =
		(
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
		)
	
	
-- test 2

	function createSpheres total iterations =
		(
		-- variables
			--total		= 1000
			--iterations	= 10
	
		-- objects
			delete objects
			s = sphere()
			pos = for i = 1 to total collect (random [-100,-100,-100] [100,100,100] )
			meshes = #()
			
		-- time stampers
			tsAll = TimeStamper("Attach Test - all")
			tsCreate = TimeStamper("Attach Test - creation")
			tsAttach = TimeStamper("Attach Test - attachment")
			
		-- main loop
			tsAll.start()
			with undo off with redraw off
				(
				
			-- create sphere groups loop
				for i = 1 to pos.count / iterations do
					(
					tsCreate.start()
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
					tsCreate.end()
					)
				)
			
			
		-- attach sphere groups loop
			with undo off with redraw off
				(
				tsAttach.start()
				for i = 2 to meshes.count do
					(
					meshop.attach meshes[1] meshes[i]
					)
				tsAttach.end()
				)
		
		-- stats
			tsAll.end()
			
		format "%	%	%	%	%\n" total iterations (tsAll.duration) (tsCreate.getTotal()) (tsAttach.duration)
		(gc())
		)
		
tsAttach

total = 5000
createSpheres total 1000
createSpheres total 500
createSpheres total 100
createSpheres total 50
createSpheres total 10

/*
	for i = 1 to 5000 by 100 do
		(
		format "Processing attach % - % seconds\n" (i as string)  (t2.durations[i] as string)
		)
	*/
-- Processing 'Attach Test - all' took 3.687 seconds. 50
-- Processing 'Attach Test - all' took 9.219 seconds. 1000

heapSize *= 10
stackSize