-------------------------------------------------------------------------------
-- RandomMapPhase.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 03/02/99
-- Modified On: 04/13/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Whichever material in the material editor you choose, this script will go in
-- and find all maps within that material that have a phase variable and assign 
-- a random number to it. This is useful if say you have two rocks, both with 
-- the same texture on it that contains several levels of procedural noise. By
-- cloning the material, applying it to the second rock, then using this script,
-- the two rocks will now have similar looking textures, but look different from
-- each other due to the phase difference.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
-- 
-- Whichever material in the material editor you choose, this script will go in
-- and find all maps within that material that have a phase variable and assign 
-- a random number to it. This is useful if say you have two rocks, both with 
-- the same texture on it that contains several levels of procedural noise. By
-- cloning the material, applying it to the second rock, then using this script,
-- the two rocks will now have similar looking textures, but look different from
-- each other due to the phase difference.
--
-- v 1.01 Added version number to titlebar.
--
-- v 1.10 Name changed from RandomPhase to RandomMapPhase. Also, the script only
-- works on the currently selected material slot now. Updated for R4.0
--
-- v 1.11 Fixed a bug that caused the script to not work on Blend Materials,
-- Multi/sub-object materials, etc. The script is now slower because it has
-- to search through more stuff, but at least now it's sure to get everything.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global changephase

-- Functions

fn changephase onwhat = 
	(
	undo "RandomMapPhase" on
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
								if (getSubAnimNames onwhat[i])[j] == #phase then
								onwhat[i].phase = random 0 1000
								)
							)
						)
					)
				changephase onwhat[i]
				)
			)
		)
	)

-- Script

if (queryBox "Randomly change all map phases in the currently selected material slot?" title:"RandomMapPhase") == true then changephase meditMaterials[medit.GetActiveMtlSlot()]
)
-------------------------------------------------------------------------------