-------------------------------------------------------------------------------
-- RemoveNoiseAnimation.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 03/10/99
-- Modified On: 04/08/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Ever get pissed off when you apply a noise modifier to an object, open 
-- trackview and say show animated and you see the noise phase has already been 
-- animated for you even though you have no desire to see it since you don't
-- need it animated anyways? Well, me to. This takes any phase animation in
-- any noise modifier in any selected object and deletes the keys.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Ever get pissed off when you apply a noise modifier to an object, open 
-- trackview and say show animated and you see the noise phase has already been 
-- animated for you even though you have no desire to see it since you don't
-- need it animated anyways? Well, me to. This takes any phase animation in
-- any noise modifier in any selected object and deletes the keys.
--
-- v 1.01 Added version to titlebar.
--
-- v 1.10 Compatible with R4.0
--
-- v 1.11 Added a progress bar.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global killnoiseanim

-- Functions

fn killnoiseanim onwhat = 
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
							if (getSubAnimNames onwhat[i])[j] == #Noise then deletekeys onwhat[i][j][8]
						)
					)
				)
			)
			killnoiseanim onwhat[i]
		)
	)
)

-- The Script

if selection.count == 0 then (MessageBox "Please select at least one object" title:"RemoveNoiseAnimation")
else 
(
	undo "RemoveNoiseAnimation" on
	(
		if (queryBox "Remove all phase animation from any Noise Modifiers in selection?" title:"RemoveNoiseAnimation") == true then 
		(
			progressStart "Make Unique"
			escapeEnable = false
			total = selection.count
			for i = 1 to total do
			(
				m = ((i as float)/(total as float))*100
				killnoiseanim selection[i]
				progressUpdate m
			)
			progressEnd()
		)
	)
)
)
-------------------------------------------------------------------------------