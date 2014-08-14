-- ------------------------------------------------------------------------------------------------------------------------
--
--	######                    ##   ##                   
--	##                        ##                        
--	##     ## ## ##### ##### ##### ## ##### ##### ##### 
--	#####  ## ## ## ## ##     ##   ## ## ## ## ## ##    
--	##     ## ## ## ## ##     ##   ## ## ## ## ## ##### 
--	##     ## ## ## ## ##     ##   ## ## ## ## ##    ## 
--	##     ##### ## ## #####  #### ## ##### ## ## ##### 
--
-- ------------------------------------------------------------------------------------------------------------------------
-- Functions


	function trajectoryAsArray obj =
	(
		local arr	= for t = 0 to animationrange.end collect at time t obj.pos
		arr
	)
	
	function tragectoryToSpline arr =
	(
		-- spline
			local ss = SplineShape pos:arr[1]
			addNewSpline ss
			
		-- knots
			for i = 1 to arr.count do
			(
				addKnot ss 1 #corner #line arr[i]
			)
			updateShape ss
			
		-- return
			ss
	)
	
	function particleTrajectoryToArray pf index =
	(
		local arr	= #()
		for t = 0 to animationrange.end do
		(
			pf.updateParticles pf t
			append arr (pf.getParticlePositionById index)
		)
		arr
	)
	
	struct pData (pos, rot)
		
	function getAllParticleData pf numParticles:#all =
	(
		-- variables
			local pos
			local rot
			local tm

		-- num particles
			if numParticles == #all do numParticles = pf.numParticles()
			
		-- create initial arrays
			local arr = #()
			for p = 1 to numParticles do
			(
				arr[p] = #()
			)
	
		-- loop through time
			for t = 0 to animationrange.end do
			(
				pf.updateParticles pf t
				--gc()
				for p = 1 to numParticles do
				(
					--tm		= pf.getParticleTM p
					--pos		= tm.pos
					--rot		= tm.rotation as eulerangles
					
					pf.particleIndex	= p
					pos					= pf.particlePosition
					rot					= pf.particleOrientation
					
					local posData		= [pos.x as integer, pos.y as integer, pos.z as integer]
					local rotData		= [radToDeg rot.x as integer, radToDeg rot.y as integer, radToDeg rot.z as integer]
					
					d					= pData pos:posData rot:rotData
					append arr[p] d
				)
			)
		arr
	)
	
	
-- ---------------------------------------------------------------------------------------------------------
--
--	##  ##            ##       ##    ##             
--	##  ##                     ##    ##             
--	##  ## ##### #### ## ##### ##### ## ##### ##### 
--	##  ##    ## ##   ##    ## ## ## ## ## ## ##    
--	##  ## ##### ##   ## ##### ## ## ## ##### ##### 
--	 ####  ## ## ##   ## ## ## ## ## ## ##       ## 
--	  ##   ##### ##   ## ##### ##### ## ##### ##### 
--
-- ---------------------------------------------------------------------------------------------------------
-- Variables


	-- spline testing
		pf = $'PF Source 01'
		for i = 1 to 131 by 5 do
		(
			arr = particleTrajectoryToArray pf 1
			tragectoryToSpline arr
		)
		
		
	-- all data		
		arrAll = getAllParticleData pf numParticles:10
		

	-- recheck positions
		d = arrAll[10]
		arr = for i = 1 to d.count collect d[i].pos
		tragectoryToSpline arr


p = point()

with animate on for i = 1 to d.count do at time i p.pos = d[i].pos

		
		--$.rotation.controller
		
		
		numKnots $ 1
