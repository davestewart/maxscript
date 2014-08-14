-------------------------------------------------------------------------------
-- ProceduralMapScale.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 04/13/01
-- Modified On: 04/13/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes all procedural maps in a material and multiplies, adds or changes their 
-- size based on a value. Good for quickly changing the size of all procedurals
-- in a material at the same time. Works on BlurGradient, BlurNoise, Camoflage, 
-- Cellular, Dent, DynoSkin, Electric, Gradient, Marble, Noise, Smoke, Splat, 
-- Speckle, and Stucco.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Known Bugs and Issues:
--
-- The two big procedurals types that this script won't work on is DarkTree and 
-- Worley textures. Neither are maxscript accessible, so they won't work until 
-- they become accesssible.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global changesize

global pms_rollout
global pms_floater

-- Varibales

pms_type_value = 2
pms_value = 2

-- Functions

fn changesize onwhat = 
	(
	undo "ProceduralMapScale" on
		(	
		if onwhat.numsubs != 0 then
			(
			for i = 1 to onwhat.numsubs do
				(
				if onwhat[i] != undefined then
					(
					if onwhat[i].numsubs != 0 then
						(
						for j = 1 to onwhat[i].numsubs do
							(
							if onwhat[i][j] != undefined then
								(
								if (getSubAnimNames onwhat[i])[j] == #Noise_Size or (getSubAnimNames onwhat[i])[j] == #size then
									(
									keeplooking = true
									try 	
										(
										oldsize = onwhat[i].size
										if pms_type_value == 1 then onwhat[i].size = oldsize + pms_value
										else if pms_type_value == 2 then onwhat[i].size = oldsize * pms_value
										else if pms_type_value == 3 then onwhat[i].size = pms_value
										keeplooking = false
										)
									catch ()
									if keeplooking == true then
										(
										try 	
											(
											oldsize = onwhat[i].noiseSize
											if pms_type_value == 1 then onwhat[i].noiseSize = oldsize + pms_value
											else if pms_type_value == 2 then onwhat[i].noiseSize = oldsize * pms_value
											else if pms_type_value == 3 then onwhat[i].noiseSize = pms_value
											)
										catch ()
										)
									)									
								)
							)
						)
					)
				changesize onwhat[i]
				)
			)
		)
	)

-- Script

rollout pms_rollout "ProceduralMapScale"
	(
	dropdownlist pms_type "" items:#("Add", "Multiply", "Absolute") selection:2 align:#center
	spinner pms_value_spinner "Value: " range:[-999999,999999,2] type:#float fieldWidth:50 align:#center
	button pms_do "Scale The Maps" width:160 align:#center toolTip:"Scale The Maps"

	on pms_type selected i do pms_type_value = i
	on pms_value_spinner changed val do pms_value = val
	on pms_do pressed do 
		(
		changesize meditMaterials[medit.GetActiveMtlSlot()]
		)
	)

if pms_floater != undefined then CloseRolloutFloater pms_floater
pms_floater = newRolloutFloater "ProceduralMapScale v1.00" 200 143
addRollout pms_rollout pms_floater
)
-------------------------------------------------------------------------------