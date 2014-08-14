-- (c) Pietro Salerno 2007, info@3rdpole.com
-- simple birth script
-- based on container vertex count
-- name the emitter as "Container", must be an aditable mesh...

on ChannelsUsed pCont do
(
  pCont.usePosition = true
)

on Init pCont do 
(
 global obj = $Container
 global vCount = getNumVerts obj
)

on Proceed pCont do 
(
 if currenttime==0 do
 (
  for i in 1 to vCount do
    (
    
	-- particle creation
	pCont.AddParticle()
    pCont.particleIndex = i
   
	-- particle position
	vpos = getVert obj i
    pCont.particlePosition = vpos
	
    )
 )

)

on Release pCont do 
(
)

--********************************************************************
--Interface: MaxscriptParticleContainer - argument in all script methods
-- Properties:
--				// to use in ChannelsUsed method
--  .useTime : bool : Read|Write
--  .useAge : bool : Read|Write
--  .useLifespan : bool : Read|Write
--  .useEventTime : bool : Read|Write
--  .usePosition : bool : Read|Write
--  .useSpeed : bool : Read|Write
--  .useAcceleration : bool : Read|Write
--  .useOrientation : bool : Read|Write
--  .useSpin : bool : Read|Write
--  .useScale : bool : Read|Write
--  .useTM : bool : Read|Write
--  .useSelected : bool : Read|Write
--  .useShape : bool : Read|Write
--  .useMtlIndex: bool: Read|Write
--  .useMapping: bool: Read|Write
--  .useInteger : bool : Read|Write
--  .useFloat : bool : Read|Write
--  .useVector : bool : Read|Write
--  .useMatrix : bool : Read|Write
--				// to use in Proceed method
--  .particleIndex : index : Read|Write|Validated by Range: 1 to 100000000	// set/get current particle index
--  .particleID : index : Read|Write|Validated by Range: 1 to 100000000		// set/get current particle ID
--  .particleNew : bool : Read		// check if particle just arrived into the event
--  .particleTime : time : Read|Write  // time of the current status of the particle
--  .particleAge : time : Read|Write|Validated by Range: 0f to 9e+006f
--  .particleLifespan : time : Read|Write|Validated by Range: 0f to 9e+006f
--  .particleEventTime : time : Read|Write|Validated by Range: 0f to 9e+006f // for how long the particle is present in the current event
--  .particlePosition : point3 : Read|Write
--  .particleSpeed : point3 : Read|Write
--  .particleAcceleration : point3 : Read|Write
--  .particleOrientation : point3 : Read|Write
--  .particleSpin : angleAxis : Read|Write
--  .particleScale : float : Read|Write
--  .particleScaleXYZ : point3 : Read|Write
--  .particleTM : matrix3 : Read|Write		// set/get particle transformation matrix 
--  .particleSelected : bool : Read|Write
--  .particleShape : mesh : Read|Write
--  .particleInteger : integer : Read|Write // to store custom integer data per particle
--  .particleFloat : float : Read|Write		// to store custom float data per particle
--  .particleVector : point3 : Read|Write	// to store custom vector data per particle
--  .particleMatrix : matrix3 : Read|Write	// to store custom matrix data per particle
-- Methods:
--				// to use in Init, Release and Proceed methods
--  <IObject>getParticleContainer()	// get particle container
--				// to use in Init and Proceed methods
--  <object>getParticleSystem()		// get the particle system object
--  <node>getParticleSystemNode()	// get the particle system node
--				// to use in Init method
--  <object array>getInitActions()	// get list of all action objects in the current event
--  <node array>getInitActionNodes()// get list of all action nodes in the current event
--				// to use in Proceed method
--  <time>getTimeStart()			// get start of the proceed interval
--  <time>getTimeEnd()				// get end of the proceed interval
--  <void>setTimeEnd <time>time		// if it is not possible to proceed all particles to the given timeEnd
--									// then set the closest possible time of the proceed interval
--  <void>setTimeEndPrecise <time>time <float>fraction  // to set the end time with higher precision
--  <node>getActionNode()			// get node the action
--  <Interface>getIntegrator()		// get interface of the procedure that integrates particle motion in time
--  <integer>randSign()				// get random sign (-1 or +1)
--  <float>rand01()					// get random number from interval [0, 1]
--  <float>rand11()					// get random number from interval [-1, 1]
--  <float>rand55()					// get random number from interval [-0.5, 0.5]
--  <integer>rand0X <integer>maxNumber // get random integer number from interval [0..maxNumber]
--  <point3>randSpherePoint()		// get random 3D point from surface of sphere with radius 1
--  <point3>randDivergeVector <point3>vectorToDiverge <angle>maxAngle // get random vector that diverges
--									// from the given vector for no more that maxAngle angle
--  <integer>numParticles()			// number of particles in the current event
--  <bool>addParticle()				// add a single particle. Use .particleTime to define when particle is added
--									// Use .particleAge=0 to set particle age to zero
--									// Use other methods to define particle position, speed, orientation etc.
--  <bool>addParticles <integer>amount  // add 'amount' particles
--  <bool>deleteParticle <index>index // delete a single particle with the given index
--  <bool>deleteParticles <index>startIndex <integer>amount // delete 'amount' particles starting from startIndex
--  <index>getParticleID <index>particleIndex // get ID of the particle with the given index
--  <bool>hasParticleID <index>particleID <&index>particleIndex // verify if the event has a particle with the given ID
--     particleIndex is In and Out parameter					// if the particle is present then particleIndex is the index of the particle
--  <bool>isParticleNew <index>particleIndex	// check if a particle just arrived into the event
--  <bool>isParticleNewByID <index>particleID   // check if a particle with the given ID just arrived into the event
--  <time>getParticleTime <index>particleIndex  // get time of the current status of the particle
--  <time>getParticleTimeByID <index>particleID
--  <void>setParticleTime <index>particleIndex <time>time  // change time of the current status of the particle
--  <void>setParticleTimePrecise <index>particleIndex <time>time <float>fraction
--  <void>setParticleTimeByID <index>particleID <time>time
--  <void>setParticleTimePreciseByID <index>particleID <time>time <float>fraction
--  <time>getParticleAge <index>particleIndex
--  <time>getParticleAgeByID <index>particleID
--  <void>setParticleAge <index>particleIndex <time>age
--  <void>setParticleAgeByID <index>particleID <time>age
--  <time>getParticleLifespan <index>particleIndex
--  <time>getParticleLifespanByID <index>particleID
--  <void>setParticleLifespan <index>particleIndex <time>lifespan
--  <void>setParticleLifespanByID <index>particleID <time>lifespan
--  <time>getParticleEventTime <index>particleIndex
--  <time>getParticleEventTimeByID <index>particleID
--  <void>setParticleEventTime <index>particleIndex <time>eventTime
--  <void>setParticleEventTimeByID <index>particleID <time>eventTime
--  <point3>getParticlePosition <index>particleIndex
--  <point3>getParticlePositionByID <index>particleID
--  <void>setParticlePosition <index>particleIndex <point3>position
--  <void>setParticlePositionByID <index>particleID <point3>position
--  <point3>getParticleSpeed <index>particleIndex
--  <point3>getParticleSpeedByID <index>particleID
--  <void>setParticleSpeed <index>particleIndex <point3>speed
--  <void>setParticleSpeedByID <index>particleID <point3>speed
--  <point3>getParticleAcceleration <index>particleIndex
--  <point3>getParticleAccelerationByID <index>particleID
--  <void>setParticleAcceleration <index>particleIndex <point3>acceleration
--  <void>setParticleAccelerationByID <index>particleID <point3>acceleration
--  <point3>getParticleOrientation <index>particleIndex
--  <point3>getParticleOrientationByID <index>particleID
--  <void>setParticleOrientation <index>particleIndex <point3>orientation
--  <void>setParticleOrientationByID <index>particleID <point3>orientation
--  <angleAxis>getParticleSpin <index>particleIndex
--  <angleAxis>getParticleSpinByID <index>particleID
--  <void>setParticleSpin <index>particleIndex <angleAxis>spin
--  <void>setParticleSpinByID <index>particleID <angleAxis>spin
--  <float>getParticleScale <index>particleIndex
--  <float>getParticleScaleByID <index>particleID
--  <void>setParticleScale <index>particleIndex <float>scale
--  <void>setParticleScaleByID <index>particleID <float>scale
--  <point3>getParticleScaleXYZ <index>particleIndex
--  <point3>getParticleScaleXYZByID <index>particleID
--  <void>setParticleScaleXYZ <index>particleIndex <point3>scale
--  <void>setParticleScaleXYZByID <index>particleID <point3>scale
--  <matrix3>getParticleTM <index>particleIndex
--  <matrix3>getParticleTMByID <index>particleID
--  <void>setParticleTM <index>particleIndex <matrix3>transformationMatrix
--  <void>setParticleTMByID <index>particleID <matrix3>transformationMatrix
--  <bool>getParticleSelected <index>particleIndex
--  <bool>getParticleSelectedByID <index>particleID
--  <void>setParticleSelected <index>particleIndex <bool>selected
--  <void>setParticleSelectedByID <index>particleID <bool>selected
--  <mesh>getParticleShape <index>particleIndex
--  <mesh>getParticleShapeByID <index>particleID
--  <void>setParticleShape <index>particleIndex <mesh>shape
--  <void>setParticleShapeByID <index>particleID <mesh>shape
--  <void>setShapeForAllParticles <mesh>shape
--  <void>setParticleMtlIndex <index>particleIndex <index>materialIndex
--  <void>setParticleMtlIndexByID <index>particleID <index>materialIndex
--  <void>setMtlIndexForAllParticles <index>materialIndex
--  <void>setParticleMapping <index>particleIndex <int>mapChannel <point3>mapValue
--  <void>setParticleMappingByID <index>particleID <int>mapChannel <point3>mapValue
--  <void>setMappingForAllParticles <int>mapChannel <point3>mapValue
--  <integer>getParticleInteger <index>particleIndex
--  <integer>getParticleIntegerByID <index>particleID
--  <void>setParticleInteger <index>particleIndex <integer>integerValue
--  <void>setParticleIntegerByID <index>particleID <integer>integerValue
--  <float>getParticleFloat <index>particleIndex
--  <float>getParticleFloatByID <index>particleID
--  <void>setParticleFloat <index>particleIndex <float>floatValue
--  <void>setParticleFloatByID <index>particleID <float>floatValue
--  <point3>getParticleVector <index>particleIndex
--  <point3>getParticleVectorByID <index>particleID
--  <void>setParticleVector <index>particleIndex <point3>vectorValue
--  <void>setParticleVectorByID <index>particleID <point3>vectorValue
--  <matrix3>getParticleMatrix <index>particleIndex
 
--  <matrix3>getParticleMatrixByID <index>particleID
--  <void>setParticleMatrix <index>particleIndex <matrix3>matrixValue
--  <void>setParticleMatrixByID <index>particleID <matrix3>matrixValue
 
