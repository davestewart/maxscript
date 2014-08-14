	
-- test 2

	tsAll = TimeStamper("Attach Test - all")
	tsCreate = TimeStamper("Attach Test - creation")
	tsSphereAttach = TimeStamper("Attach Test - sphere attachment")
	tsGroupAttach = TimeStamper("Attach Test - sphere group attachment")
	
	
	function createSpheres total chunkSize =
	(
		-- variables
			--total		= 1000
			--chunkSize	= 10
	
		-- objects
			delete objects
			s = sphere()
			pos = for i = 1 to total collect (random [-100,-100,-100] [100,100,100] )
			meshes = #()
			count = 0
			
		-- time stampers
		-- main loop
			tsAll.start()
			with undo off with redraw off
			(
				
			-- create sphere groups loop
				for i = 1 to pos.count / chunkSize do
				(
					tsCreate.start()
					b = box()
					converttomesh b
					
				-- create spheres loop
					for j = 1 to chunkSize do
					(
						tsSphereAttach.start()
						index = ((i - 1)* chunkSize) + j
						s.pos = pos[index]
						meshop.attach b s deleteSourceNode:false
						tsSphereAttach.end()
						count += 1
						if count >= total do exit
					)
					append meshes b
					tsCreate.end()
					if count == total do exit
				)
			)
			
			
		-- attach sphere groups loop
			with undo off with redraw off
			(
				tsGroupAttach.start()
				for i = 2 to meshes.count do
				(
					meshop.attach meshes[1] meshes[i]
				)
				tsGroupAttach.end()
			)
		
		-- stats
			tsAll.end()
			
		format "%	%	%	%	%	%\n" total chunkSize ((ceil total / chunkSize as float) as integer) (tsAll.duration) (tsCreate.getTotal()) (tsGroupAttach.duration)
		(gc())
	)
		
		
	function getCumulativeTimes =
	(
		durations = tsSphereAttach.durations
		cumulative = 0
		for i = 1 to durations.count by 100 do
		(
			local total = 0
			for j = 1 to 100 do
			(
				total += durations[(i - 1) + j]
			)
			local avg = total / 100.0
			cumulative += total
			format "%	%	%	%\n" (i / 100) avg total cumulative
		)
	)



-- objects total
	total = 1000

	createSpheres 3000 3000

/*	
-- chunks total
	createSpheres total total
	createSpheres total 1000
	createSpheres total 500
	createSpheres total 100
	createSpheres total (sqrt total as integer)
	createSpheres total 50
	createSpheres total 10
	
-- get attach times
	getCumulativeTimes()
	
durs = tsSphereAttach.durations
tsSphereAttach--.getReport()
	
*/



tsSphereAttach.getReport output:#window step:10

