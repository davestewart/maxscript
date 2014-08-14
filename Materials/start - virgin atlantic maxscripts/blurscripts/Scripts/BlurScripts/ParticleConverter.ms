-------------------------------------------------------------------------------
-- ParticleConverter.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 06/30/00
-- Modified On: 08/01/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Will convert a SuperSpray, Pcloud or PArray to any other of the three systems,
-- keeping as many parameters as it can with the conversion.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- I have no access to the Material SOurce of a superspray, so that info will 
-- not get converted.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Will convert a SuperSpray, Pcloud or PArray to any other of the three 
-- systems, keeping as many parameters as it can with the conversion.
--
-- v 1.10 Now compatible with R4.0.
--
-- v 1.11 Finished the code to properly convert Material Source. Please note
-- I have no access to the Material SOurce of a superspray, so that info will 
-- not get converted.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global dothechange
global canidothechange

global pcr_floater
global pcr_rollout

global pt_from = 0
global pt_to = 0
global new_part

-- Variables

sn = 0
adj = 0.9

-- Functions

fn dothechange tho thno = 
(
	thno.rotation = tho.rotation
	thno.scale = tho.scale

	if pt_from == 0 then sn = (tho.iconsize) * adj
	if pt_from == 1 then sn = (tho.iconsize * 0.5) * adj
	if pt_from == 2 then sn = (tho.Emitter_Rad_Len * 0.5) * adj
	thno.pos = tho.pos + [sn,sn,0]

	thno.material = tho.material

-- Emitter

	if pt_from != 0 and pt_to != 0 and tho.emitter != undefined then thno.emitter = tho.emitter

-- Icon Size

	if pt_from == 2 and pt_to == 2 then 
	(
		thno.Emitter_Rad_Len = tho.Emitter_Rad_Len
		thno.Emitter_Width = tho.Emitter_Width
		thno.Emitter_Height = tho.Emitter_Height
	)
	if pt_from == 2 and pt_to == 1 then
	(
		thno.iconsize = tho.Emitter_Rad_Len
	)
	if pt_from == 2 and pt_to == 0 then
	(
		thno.iconsize = (tho.Emitter_Rad_Len * 0.5)
	)

	if pt_from == 1 and pt_to == 2 then 
	(
		thno.Emitter_Rad_Len = tho.iconsize
		thno.Emitter_Width = tho.iconsize
		thno.Emitter_Height = tho.iconsize
	)
	if pt_from == 1 and pt_to == 1 then
	(
		thno.iconsize = tho.iconsize
	)
	if pt_from == 1 and pt_to == 0 then
	(
		thno.iconsize = tho.iconsize * 0.5
	)

	if pt_from == 0 and pt_to == 2 then 
	(
		thno.Emitter_Rad_Len = tho.iconsize * 2
		thno.Emitter_Width = tho.iconsize * 2
		thno.Emitter_Height = tho.iconsize * 2
	)
	if pt_from == 0 and pt_to == 1 then
	(
		thno.iconsize = tho.iconsize * 2
	)
	if pt_from == 0 and pt_to == 0 then
	(
		thno.iconsize = tho.iconsize
	)

-- Icon Hidden

	if pt_from == 2 and pt_to == 2 then thno.emitterHidden = tho.emitterHidden
	else
	(
		if pt_from == 2 then thno.iconHidden = tho.emitterHidden
		else 
		(
			if pt_to == 2 then thno.emitterHidden = tho.iconHidden
			else thno.iconHidden = tho.iconHidden
		)
	)
                          
	thno.viewPercent = tho.viewPercent
	thno.viewType = tho.viewType

	thno.quantityMethod = tho.quantityMethod
	thno.Birth_Rate = tho.Birth_Rate
	thno.Total_Number = tho.Total_Number

	thno.speed = tho.speed
	thno.Speed_Variation = tho.Speed_Variation

	thno.Emitter_Start = tho.Emitter_Start
	thno.Emitter_Stop = tho.Emitter_Stop
	thno.Display_Until = tho.Display_Until
	thno.life = tho.life
	thno.Life_Variation = tho.Life_Variation

	thno.size = tho.size
	thno.Size_Variation = tho.Size_Variation
	thno.Growth_Time = tho.Growth_Time
	thno.Fade_Time = tho.Fade_Time

	thno.seed = tho.seed

-- Particle Type

	if pt_from == 1 and pt_to == 1 then thno.particleType = tho.particleType
	else
	(
		if pt_to == 1 and tho.particleType == 2 then thno.particleType = 3
		else
		(
			if pt_from == 1 and tho.particletype == 3 then thno.particleType = 2
			else thno.particleType = tho.particleType
		)
	)

	thno.standardParticle = tho.standardParticle

	thno.Metaparticle_Tension = tho.Metaparticle_Tension
	thno.Metaparticle_Tension_Variation = tho.Metaparticle_Tension_Variation
	thno.metaballRenderCoarsness = tho.metaballRenderCoarsness
	thno.metaballViewCoarsness = tho.metaballViewCoarsness
	thno.metaballAutoCoarsness = tho.metaballAutoCoarsness

	if tho.instancingObject != undefined then (thno.instancingObject = tho.instancingObject)
	thno.instanceSubTree = tho.instanceSubTree
	thno.instanceKeyOffsetType = tho.instanceKeyOffsetType
	thno.instanceFrameOffset = tho.instanceFrameOffset

	thno.mappingType = tho.mappingType
	thno.Mapping_Time_Base = tho.Mapping_Time_Base
	thno.Mapping_Distance_Base = tho.Mapping_Distance_Base
	
-- Material Source

	matsource = ""
	if pt_from == 2 then
	(
		if tho.materialSource == 0 then matsource = "icon"
		else matsource = "inst"
	)
	else if pt_from == 1 then
	(
		if tho.materialSource == 0 then matsource = "icon"
		else if tho.materialSource == 1 then matsource = "picked"
		else matsource = "inst"
	)
	if pt_to == 2 then
	(
		if matsource == "icon" then thno.materialSource = 0
		else if matsource == "inst" then thno.materialSource = 1
	)
	else if pt_to == 1 then
	(
		if matsource == "icon" then thno.materialSource = 0
		else if matsource == "picked" then thno.materialSource = 1
		else if matsource == "inst" then thno.materialSource = 2
	)

-- Rotation And Collision

	thno.Spin_Time = tho.Spin_Time
	thno.Spin_Time_Variation = tho.Spin_Time_Variation
	thno.Spin_Phase = tho.Spin_Phase
	thno.Spin_Phase_Variation = tho.Spin_Phase_Variation
	thno.spinAxisType = tho.spinAxisType
	thno.Blur_Stretch = tho.Blur_Stretch
	thno.X_Spin_Vector = tho.X_Spin_Vector
	thno.Y_Spin_Vector = tho.Y_Spin_Vector
	thno.Z_Spin_Vector = tho.Z_Spin_Vector
	thno.Spin_Axis_Variation = tho.Spin_Axis_Variation
	thno.Interparticle_Collisions_On = tho.Interparticle_Collisions_On
	thno.Interparticle_Collision_Steps = tho.Interparticle_Collision_Steps
	thno.Interparticle_Collision_Bounce = tho.Interparticle_Collision_Bounce
	thno.Interparticle_Collision_Bounce_Variation = tho.Interparticle_Collision_Bounce_Variation

	thno.motionInfluence = tho.motionInfluence
	thno.motionMultiplier = tho.motionMultiplier
	thno.motionVariation = tho.motionVariation

	thno.Bubble_Amplitude = tho.Bubble_Amplitude
	thno.Bubble_Amplitude_Variation = tho.Bubble_Amplitude_Variation
	thno.Bubble_Period = tho.Bubble_Period
	thno.Bubble_Period_Variation = tho.Bubble_Period_Variation
	thno.Bubble_Phase = tho.Bubble_Phase
	thno.Bubble_Phase_Variation = tho.Bubble_Phase_Variation

	thno.spawnType = tho.spawnType
	thno.Die__X_frames_after_collision = tho.Die__X_frames_after_collision
	thno.Die__X_frames_after_collision_variation = tho.Die__X_frames_after_collision_variation

	if pt_from != 0 and pt_to != 0 then thno.Spawn_Generations = tho.Spawn_Generations

	if pt_from != 2 and pt_to != 2 then thno.Spawn_Affects = tho.Spawn_Affects

	if pt_from != 0 and pt_to != 0 then thno.Spawn_Multiplier = tho.Spawn_Multiplier

	if pt_from != 2 and pt_to != 2 then thno.Spawn_Multiplier_Variation = tho.Spawn_Multiplier_Variation

	thno.Spawn_Direction_Chaos = tho.Spawn_Direction_Chaos
	thno.Spawn_Speed_Chaos = tho.Spawn_Speed_Chaos
	thno.spawnSpeedType = tho.spawnSpeedType
	thno.spawnInheritVelocity = tho.spawnInheritVelocity
	thno.spawnSpeedFixed = tho.spawnSpeedFixed
	thno.Spawn_Scale_Chaos = tho.Spawn_Scale_Chaos
	thno.spawnScaleType = tho.spawnScaleType
	thno.spawnScaleFixed = tho.spawnScaleFixed
	thno.lifespanValueQueue = tho.lifespanValueQueue

	if pt_from != 0 and pt_to != 0 then thno.Spawn_Lifespan = tho.Spawn_Lifespan

	thno.objectMutationQueue = tho.objectMutationQueue
)

fn canidothechange = 
(
	if selection.count == 0 then (MessageBox "Please select at least one object" title:"ParticleConverter")
	else
	(
		undo "ParticleConverter" on
		(
			for i in selection do
			(
				if classof i.baseobject == SuperSpray or classof i.baseobject == PArray or classof i.baseobject == PCloud then
				(
					if classof i.baseobject == SuperSpray then pt_from = 0
					if classof i.baseobject == PArray then pt_from = 1
					if classof i.baseobject == PCloud then pt_from = 2
					if pt_to == 0 then new_part = SuperSpray ()
					if pt_to == 1 then new_part = PArray ()
					if pt_to == 2 then new_part = PCloud ()
					dothechange i new_part
				)
				else continue
			)
		)
	)
)

-- The Script

rollout pcr_rollout "ParticleConverter"
(
	group "Convert To:"
(
	dropdownlist part_type_rb "" items:#("SuperSpray", "PArray", "PCloud") selection:1
)	

	on part_type_rb selected i do pt_to = (i - 1)

	button button_do "Do the Conversion" width:150 align:#center toolTip:"Do the Conversion"
	on button_do pressed do canidothechange ()
)

if pcr_floater != undefined then CloseRolloutFloater pcr_floater
pcr_floater = newRolloutFloater "ParticleConverter v1.11" 230 147
addRollout pcr_rollout pcr_floater
)
-------------------------------------------------------------------------------