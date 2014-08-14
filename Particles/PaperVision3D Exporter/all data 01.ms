
----------------------------------------------------------------------------------------------
-- variables functions
----------------------------------------------------------------------------------------------

		struct pData (pos, rot)

		origin			= $Origin
		precision 		= 2
		
		pf				= $'PF Source 01'

----------------------------------------------------------------------------------------------
-- utility functions
----------------------------------------------------------------------------------------------

		function round n points =
		(
			if points == 0 then
			(
				n += 0.5
				n = n as integer
			)
			else
			(
				local exp = pow 10 points
				n *= exp
				n = floor n
				n /= exp
			)
			n
		)
			
		function outputData str =
		(
			clearlistener()
			format "var animation_array:Array = [\n%\n];\n\n" (str as string)
		)
		
----------------------------------------------------------------------------------------------
-- trajectory functions
----------------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------------
-- data functions
----------------------------------------------------------------------------------------------

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
						pf.particleIndex	= p
						pos					= pf.particlePosition
						rot					= pf.particleOrientation / Pi * 180
	
						append arr[p] (pData pos:pos rot:rot)
					)
				)
			arr
		)

----------------------------------------------------------------------------------------------
-- export functions
----------------------------------------------------------------------------------------------

		function exportCamera =
		(
			-- variables
				local cam			= $camera01
				local tm			= $ExposeTMCamera01
	
				local str			= stringstream ""
				
			-- loop	
				for t = 0 to 131 do
				(
					at time t
					(
						-- max coords
							mpx	= round tm.localPositionX precision
							mpy	= round tm.localPositionY precision
							mpz	= round tm.localPositionZ precision
							
							mrx	= round tm.localEulerX precision
							mry	= round tm.localEulerY precision
							mrz	= round tm.localEulerZ precision
							
						-- flash coords
							fpx	= mpx
							fpy	= mpy
							fpz	= mpz
							
							frx	= mrx - 180
							fry	= mry
							frz	= mrz
							
						-- output
							format "[%, %, %, %, %, %]" fpx fpy fpz frx fry frz to:str
							if t < 131 do format ",\n" to:str
				
					)
				)
			
			-- output
				outputData(str)
		)
	
		function exportTiles arr =
		(
			-- variables
				local cam			= $camera01
				local tm			= $ExposeTMCamera01
	
				local strBox		= stringstream ""
				local strAll		= stringstream ""
				local data
				
				format "[]," to:str
				
			-- loop	
				for b = 1 to arr.count do
				(
					strBox = stringstream ""
					for t = 1 to arr[b].count
					(
						-- object
							local data = arr[b][t]
						
						-- max coords
							mpx	= round data.pos.x precision
							mpy	= round data.pos.y precision
							mpz	= round data.pos.z precision
							
							mrx	= round data.pos.x precision
							mry	= round data.pos.y precision
							mrz	= round data.pos.z precision
							
						-- flash coords
							fpx	= mpx
							fpy	= mpy
							fpz	= mpz
							
							frx	= mrx - 180
							fry	= mry
							frz	= mrz
							
						-- output
							format "[%, %, %, %, %, %]" fpx fpy fpz frx fry frz to:strBox
							if t < arr[b].count do format ",\n" to:str
				
					)
					-- output
						format "[%]" (strBox as string) to:str
						if t < arr.count do format ",\n" to:str
				)
			
			-- output
				
				outputData(str)
		)

	
----------------------------------------------------------------------------------------------
-- code
----------------------------------------------------------------------------------------------

	particleData = getAllParticleData pf numParticles:5--#all
			
	