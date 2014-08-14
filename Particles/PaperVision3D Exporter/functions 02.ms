
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
	local n		= slidertime
	local arr	= #()
	for t = 0 to animationrange.end do
		(
		slidertime = t
		append arr (pf.getParticlePositionById index)
		)
	slidertime = n
	arr
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

struct pdata (pos, rot)
	
	
--local pos = pf.particlePosition
--local rot = pf.particleOrientation
	
function getAllParticleData pf =
	(
	-- variables
		local pos
		local rot
		local tm
		
	-- create initial arrays
		local arr			= #()
		local numParticles	= pf.numParticles()

	-- loop through time
		for t = 0 to animationrange.end do
			(
			pf.updateParticles pf t
			for p = 1 to pf.numParticles() do
				(
				tm = pf.getParticleTM p
				append arr[p] tm
				)
			)

	)



function test =
	(
	)


pf = $'PF Source 01'
for i = 1 to 131 by 5 do
	(
	arr = particleTrajectoryToArray pf i
	tragectoryToSpline arr
	)

pf.updateParticles pf 1

pf.particleIndex
pf.particlePosition

arr.count