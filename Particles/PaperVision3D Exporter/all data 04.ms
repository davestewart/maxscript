
----------------------------------------------------------------------------------------------
-- variables
----------------------------------------------------------------------------------------------

		struct pData (pos, rot)

		origin			= $Origin
		precision 		= 2
		
		pf				= $'PF Source 01'
		cam				= $'Camera - Main'

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
			
		function printData str =
		(
			format "var animation_array:Array = [\n[],\n\n%\n];\n\n" (str as string) to:(newScript())
		)

		function saveData str filename =
		(
			local fs = createFile (filename + ".as")
			format "var animation_array:Array = [\n[],\n\n%\n];\n\n" (str as string) to:fs
			flush fs
			close fs
		)
		
----------------------------------------------------------------------------------------------
-- trajectory functions
----------------------------------------------------------------------------------------------

		function trajectoryToSpline arr =
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
		
		function objectTrajectoryToArray obj =
		(
			local arr	= for t = 0 to animationrange.end collect at time t obj.pos
			arr
		)

		function particleTrajectoryToArray pf index =
		(
			local arr	= #()
			for t = 0 to animationrange.end do
			(
				pf.updateParticles pf t
				append arr (pf.getParticlePositionById index)-- 
			)
			arr
		)


----------------------------------------------------------------------------------------------
-- data functions
----------------------------------------------------------------------------------------------

		function getAllParticleData numParticles:#all =
		(
			-- variables
				local pos, rot, tm
	
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
						--pf.particleIndex	= p
						--pos	= pf.particlePosition - origin.pos
						--rot	= pf.particleOrientation / Pi * 180
						
						pos	= (pf.getParticlePositionById p) - origin.pos
						rot	= (pf.getParticleOrientationById p)-- / Pi * 180

						append arr[p] (pData pos:pos rot:rot)
					)
				)
			arr
		)

		function getParticleData p =
		(
			-- variables
				local pos
				local rot
				local tm
	
			-- num particles
				if numParticles == #all do numParticles = pf.numParticles()
				
			-- create initial arrays
				local arr = #()
		
			-- loop through time
				pf.particleIndex	= p
				for t = 0 to animationrange.end do
				(
					pf.updateParticles pf t
					--slidertime = t

					pos	= pf.particlePosition - origin.pos
					rot	= pf.particleOrientation / Pi * 180

					append arr (pData pos:pos rot:rot)
				)
					
			-- return
				arr
		)
			
			
		function getCameraData =
		(
			-- variables
				local tm	= $ExposeTMCamera01
				local arr = #()
				
			-- loop	
				for t = 0 to animationRange.end do
				(
					at time t
					(
						pos	= tm.localPosition-- - origin.pos
						rot	= tm.localEuler / pi * 180 -- convert to degrees
						append arr (pData pos:pos rot:rot)
					)
				)
					
			-- return
				arr
		)
 
----------------------------------------------------------------------------------------------
-- export functions
----------------------------------------------------------------------------------------------

		function getASArrayFromPData data =
		(
			
			-- stringstream
				local str = stringstream ""
			
			-- max coords
				mpx	= round data.pos.x precision
				mpy	= round data.pos.y precision
				mpz	= round data.pos.z precision
				
				mrx	= data.rot.x
				mry	= data.rot.y
				mrz	= data.rot.z

			-- flash coords
				fpx	= mpx
				fpy	= mpy
				fpz	= mpz
				
				frx	= mrx - 180-- - Pi
				fry	= - mry
				frz	= - mrz
				
			-- output
				format "[%, %, %, %, %, %]" fpx fpy fpz frx fry frz to:str
				
			-- return
				str as string
		)


		function exportCamera arr =
		(
			-- variables
				local strAll = stringstream ""
				local str = stringstream ""
				local data
				
			-- loop	
				for i = 1 to arr.count do
				(
					str = getASArrayFromPData arr[i]
					format "%" str to:strAll
					if i < 131 do format ",\n" to:strAll
				)
			
			-- output
				strAll
		)
	
		function exportParticles arr =
		(
			-- variables
				local cam			= $camera01
				local tm			= $ExposeTMCamera01
	
				local str			= stringstream ""
				local strBox		= stringstream ""
				local strAll		= stringstream "[],"
				
			-- loop	
				for b = 1 to arr.count do
				(
					strBox = stringstream ""
					for t = 1 to arr[b].count do
					(
						-- object
							str = getASArrayFromPData arr[b][t]							
							
						-- output
							format "%" str to:strBox
							if t < arr[b].count do format "," to:strBox
				
					)
					-- output
						format "[%]" (strBox as string) to:strAll
						if b < arr.count do format ",\n" to:strAll
				)
			
			-- output
				strAll
		)

	
----------------------------------------------------------------------------------------------
-- code
----------------------------------------------------------------------------------------------

	particleData	= getAllParticleData numParticles:#all
/*
	(
		actionscript	= exportParticles particleData
		saveData(actionscript, "tiles")
	)
	
		cameraData	= getCameraData()
	(
		actionscript	= exportCamera cameraData
		saveData actionscript "camera"
	)
	

	
b = particleData[10]
arr = for d in b collect d.pos
trajectoryToSpline arr

d = getParticleData 1
arr = for i in d collect i.pos
trajectoryToSpline arr


cameraData

cameraData[94].rot
	for i = 1 to particleData.count do
	(
		b = particleData[i]
		arr = for d in b collect d.pos
		trajectoryToSpline arr
	)
		
	paths = 	$shape* as array
	
	paths.pos += origin.pos

	b = getParticleData pf 1
	b = particleData[9]
	
	arr = for d in b collect d.pos
	trajectoryToSpline arr
*/