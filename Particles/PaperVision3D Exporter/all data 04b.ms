
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

		fn round n points =
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
			
----------------------------------------------------------------------------------------------
-- trajectory functions
----------------------------------------------------------------------------------------------

		function arrayToSpline arr =
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

		function particleTrajectoryToArray pf pIndex =
		(
			local arr	= #()
			for t = 0 to animationrange.end do
			(
				pf.updateParticles pf t
				append arr (pf.getParticlePositionById pIndex)
			)
			arr
		)


----------------------------------------------------------------------------------------------
-- data functions
----------------------------------------------------------------------------------------------

		function getAllParticleData numParticles:#all offset:[0,0,0] degrees:true =
		(
			-- variables
				local pos, rot, tm
				local rotScalar	= if degrees then 180 / Pi else 1
	
			-- num particles
				if numParticles == #all do numParticles = pf.numParticles()
				
			-- create initial arrays
				local arr = #()
				for pIndex = 1 to numParticles do
				(
					arr[pIndex] = #()
				)
		
			-- loop through time
				for t = 0 to animationrange.end do
				(
					pf.updateParticles pf t
					for pIndex = 1 to numParticles do
					(
						pos	= (pf.getParticlePositionById pIndex) - offset
						rot	= (pf.getParticleOrientationById pIndex) * rotScalar

						append arr[pIndex] (pData pos:pos rot:rot)
					)
				)
			arr
		)

		function getParticleData pIndex offset:[0,0,0] degrees:true =
		(
			-- variables
				local pos, rot, tm
				local rotScalar	= if degrees then 180 / Pi else 1
	
			-- create initial arrays
				local arr = #()
		
			-- loop through time
				for t = 0 to animationrange.end do
				(
					pf.updateParticles pf t

					pos	= (pf.getParticlePositionById pIndex)- offset
					rot	= (pf.getParticleOrientationById pIndex) * rotScalar

					append arr (pData pos:pos rot:rot)
				)
					
			-- return
				arr
		)
			
			
		function getCameraData offset:[0,0,0] degrees:true =
		(
			-- variables
				local tm		= $ExposeTMCamera01
				local arr		= #()
				
			-- loop	
				for t = 0 to animationRange.end do
				(
					at time t
					(
						pos	= tm.localPosition - offset
						rot	= tm.localEuler

						append arr (pData pos:pos rot:rot)
					)
				)
					
			-- return
				arr
		)
 /*
		function getCameraData offset:[0,0,0] degrees:true =
		(
			-- variables
				local r, rot, pos
				local arr		= #()
				local rotScalar	= if degrees then 1 else Pi * 180
				
			-- loop	
				for t = 0 to animationRange.end do
				(
					at time t
					(
						pos	= (in coordsys #world cam.position) - offset
						r	= (in coordsys #world cam.rotation) as eulerangles
						rot	= (point3 r.x r.y r.z) * rotScalar

						append arr (pData pos:pos rot:rot)
					)
				)
					
			-- return
				arr
		)
*/
----------------------------------------------------------------------------------------------
-- export functions
----------------------------------------------------------------------------------------------

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
	

----------------------------------------------------------------------------------------------
-- Flash functions
----------------------------------------------------------------------------------------------

		fn printASData str =
		(
			format "var animation_array:Array = [\n%\n];\n\n" (str as string) to:(newScript())
		)

		fn saveASData str filename =
		(
			local fs = createFile (filename + ".as")
			format "var animation_array:Array = [\n%\n];\n\n" (str as string) to:fs
			flush fs
			close fs
		)
		

		function getASArrayFromPData data =
		(
			
			-- stringstream
				local str = stringstream ""
				local mpx, mpy, mpz, mrx, mry, mrz
				local fpx, fpy, fpz, frx, fry, frz
			
			-- max coords
				mpx	= round data.pos.x precision
				mpy	= round data.pos.y precision
				mpz	= round data.pos.z precision
				
				mrx	= round data.rot.x precision
				mry	= round data.rot.y precision
				mrz	= round data.rot.z precision

			-- flash coords
				local version = 1

				case version of
				(
					
					1:(
						fpx	= mpx
						fpy	= -mpz
						fpz	= mpy
						
						frx	= mrx - 90
						fry	= -mrz
						frz	= mry
					)
						
					2:(
						fpx	= mpx
						fpy	= -mpz
						fpz	= mpy
						
						frx	= - mrx - 180
						fry	= mry
						frz	= mrz
					)
				)

				
			-- output
				format "[%, %, %, %, %, %]" fpx fpy fpz frx fry frz to:str
				
			-- return
				str as string
		)

----------------------------------------------------------------------------------------------
-- code
----------------------------------------------------------------------------------------------

cameraData = getCameraData offset:origin.pos
(
	actionscript = exportCamera cameraData
	saveASData actionscript "camera"
)

/*
particleData = getAllParticleData numParticles:#all offset:origin.pos
(
	actionscript = exportParticles particleData
	saveASData actionscript "particles"
)
	


pIndex	= 90

arr		= particleTrajectoryToArray pf pIndex
arrayToSpline arr

data	= getParticleData pIndex --offset:origin.pos
dataArr	= for p in data collect p.pos
arrayToSpline dataArr

dataCam	= for p in cameraData collect p.pos
arrayToSpline dataCam


for i = 1 to cameraData.count do
(
	with animate on at time i
	(
		i = 112
		rot =  cameraData[i].rot
		x = rot[1] 
		y = rot[2] 
		z = rot[3]
		format "% % %\n" x y z
		
		$.rotation.z = degToRad z
		$.rotation.y = degToRad y
		$.rotation.x = degToRad x
		$.pos = cameraData[i].pos
	)
)

*/
print cameraData

$.rotation.x = cameraData[50].rot.z


pf.getParticlePositionById 90