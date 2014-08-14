
----------------------------------------------------------------------------------------------
-- variables
----------------------------------------------------------------------------------------------

		global asPath, asFolder
		global getASArrayFromPData
		struct pData (pos, rot)

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

		function getAllParticleData numParticles:#all frames:#all degrees:true =
			(
			-- variables
				local pos, rot, tm
				local rotScalar	= if degrees then 180 / Pi else 1
				local mxYUp		= matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
				local mxPart, mxPartYUp

	
			-- num particles
				if numParticles == #all do numParticles = pf.numParticles()
				
			-- create initial arrays
				local arr = #()
				for pIndex = 1 to numParticles do
					(
					arr[pIndex] = #()
					)
		
			-- loop through time
				frames = if frames == #all then animationrange.end else frames
				for t = 0 to frames do
					(
					pf.updateParticles pf t
					for pIndex = 1 to numParticles do
						(
						/*
						pos	= (pf.getParticlePositionById pIndex) - offset
						rot	= (pf.getParticleOrientationById pIndex) * rotScalar
						*/
						
						mxPart		= pf.getParticleTMById pIndex
						mxPartYUp	= mxPart * mxYUp

						pos	= mxPartYUp.pos
						rot	= mxPartYUp.rotation as eulerangles

						append arr[pIndex] (pData pos:pos rot:rot)
						
						)
					)
			arr
			)

		function getParticleData pIndex frames:#all degrees:true =
			(
			-- variables
				local pos, rot, tm
				local rotScalar	= if degrees then 180 / Pi else 1
	
			-- create initial arrays
				local arr = #()
		
			-- loop through time
				frames = if frames == #all then animationrange.end else frames
				for t = 0 to frames do
					(
					pf.updateParticles pf t

					pos	= (pf.getParticlePositionById pIndex)
					rot	= (pf.getParticleOrientationById pIndex) * rotScalar

					append arr (pData pos:pos rot:rot)
					)
					
			-- return
				arr
			)
			
			
		function getCameraData frames:#all degrees:true =
			(
			-- variables
				local tm		= $ExposeTMCamera01
				local arr		= #()
				
			-- loop	
				frames = if frames == #all then animationrange.end else frames
				for t = 0 to frames do
					(
					at time t
						(
						pos	= tm.localPosition
						rot	= tm.localEuler

						append arr (pData pos:pos rot:rot)
						)
					)
					
			-- return
				arr
			)
			
			
		function getCameraData frames:#all degrees:true =
			(
			-- variables
				local r, rot, pos
				local arr		= #()
				local rotScalar	= if degrees then 1 else Pi * 180
				
			-- loop	
				frames = if frames == #all then animationrange.end else frames
				for t = 0 to frames do
					(
					at time t
						(
						pos	= in coordsys #world cam.position
						r	= (in coordsys #world cam.rotation) as eulerangles
						rot	= (point3 r.x r.y r.z) * rotScalar

						append arr (pData pos:pos rot:rot)
						)
					)
					
			-- return
				arr
			)


		function getCameraData frames:#all degrees:true =
			(
			-- variables
				local r, rot, pos
				local mxCam, mxCamYUp
				local arr		= #()
				local rotScalar	= if degrees then 1 else Pi * 180
				local mxYUp		= matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
				
			-- loop	
				frames = if frames == #all then animationrange.end else frames
				for t = 0 to frames do
					(
					at time t
						(
						
						mxCam		= cam.transform
						mxCamYUp	= mxCam * mxYUp

						pos	= mxCamYUp.pos
						rot	= mxCamYUp.rotation as eulerangles

						append arr (pData pos:pos rot:rot)
						)
					)
					
			-- return
				arr
			)


 /*
*/
----------------------------------------------------------------------------------------------
-- export functions
----------------------------------------------------------------------------------------------

		function exportParticles arr frames:#all =
			(
			-- variables
				local cam			= $camera01
				local tm			= $ExposeTMCamera01
	
				local str			= stringstream ""
				local strBox		= stringstream ""
				local strAll		= stringstream "[],"
				
			-- loop	
				frames = frames = if frames == #all then arr.count else frames
				for b = 1 to frames do
					(
					strBox = stringstream ""
					for t = 1 to arr[b].count do
						(
						-- object
							str = getASArrayFromPData arr[b][t]	type:"particles"						
							
						-- output
							format "%" str to:strBox
							if t < arr[b].count do format "," to:strBox
				
						)
					-- output
						format "[%]" (strBox as string) to:strAll
						if b < frames do format ",\n" to:strAll
					)
			
			-- output
				strAll
			)

		function exportCamera arr frames:#all =
			(
			-- variables
				local strAll		= stringstream ""
				local str			= stringstream ""
				
			-- loop	
				frames = if frames == #all then arr.count else frames
				for i = 1 to frames do
					(
					str = getASArrayFromPData arr[i] type:"camera"
					format "%" str to:strAll
					if i < frames do format ",\n" to:strAll
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

		fn saveASData str type =
			(
			-- filename
				local filename
				local asScene
				
			-- scene
				--asScene = if findstring maxfilename "content" != undefined then "content" else "intro"
				asScene = (filterstring maxfilename " ")[1]
				
			-- filepath
				if type == "camera" then
					filename = asPath + asScene + "/" + asScene + "Camera" + ".as"
				else
					filename = asPath + asScene + "/" + asScene + ".as"
				
			-- file
				local fs = createFile filename
				format "var animation_array:Array = [\n%\n];\n\n" (str as string) to:fs
				flush fs
				close fs
				
			-- print 
				format "Exported to file: %\n" filename
			)
		

		function getASArrayFromPData data type: =
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
				local type = "camera"

				case type of
					(
					
					"particles":
						(
						fpx	= mpx
						fpy	= mpz
						fpz	= mpy
						
						frx	= 90 - mrx
						fry	= mry
						frz	= mrz
						)
					"camera":
						(
						fpx	= mpx
						fpy	= -mpy
						fpz	= mpz
						
						frx	= - mrx + 180
						fry	= mry
						frz	= mrz
						)
						
					"new":
						(
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

asPath		= "E:/02 - Current Jobs/2008-03 - GT/pv3d/v2 - working/animations/"

cam = $'Camera - Main'
cameraData = getCameraData()
	(
	actionscript = exportCamera cameraData
	saveASData actionscript "camera"
	)

particleData = getAllParticleData numParticles:#all frames:1
	(
	actionscript = exportParticles particleData
	saveASData actionscript "content"
	)
	
	
/*
	


pIndex	= 90

arr		= particleTrajectoryToArray pf pIndex
arrayToSpline arr

data	= getParticleData pIndex
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

print cameraData

$.rotation.x = cameraData[50].rot.z
*/


pf.getParticlePositionById 90