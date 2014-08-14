-------------------------------------------------------------------------------
-- ParticleControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.42
-- Created On: 03/01/00
-- Modified On: 02/15/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Will change various particle system related values globally for all 
-- selected systems, even between dissimilar particle systems.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Will change various particle system related values globally for all 
-- selected systems, even between dissimilar particle systems.
--
-- v 1.10 Added some more accessible parameters and made the interface more
-- visually appealing.
--
-- v 1.11 The script now properly greys out unused parameters.
--
-- v 1.12 Added version number to titlebar.
--
-- v 1.20 Added a bunch of new things it can control.
--
-- v 1.30 Added a few more...
--
-- v 1.40 Renamed ParticleBuddy ParticleControl to retain consistency in 
-- script names. Now Compatible with R4.0.
--
-- v 1.41 The main particle filter has been moved to BSLib. Changed the floater
-- closing code from a try / catch to an undefined test. Changed the name of the
-- isthisaparticlesystem function to pc_chooseobject and increased the efficiency
-- of the main function by removing the selection[theoebject] and have it work 
-- on o which is already the selected object.
--
-- v 1.42 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals 

global dotheupdate
global pc_chooseobject

global pc_floater
global pc_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

do_displaycount_value = 0
do_iconsize_value = 0
do_birthrate_value = 0
do_speed_value = 0
do_speed_var_value = 0
do_emitstart_value = 0
do_emitstop_value = 0
do_displayuntil_value = 0
do_life_value = 0
do_life_variation_value = 0
do_size_value = 0
do_size_variation_value = 0
do_growfor_value = 0
do_fadefor_value = 0
do_newseed_value = 0
do_facing_value = 0

displaycount_value = 10
iconsize_value = 50
birthrate_value = 10
speed_value = 10
speed_var_value = 0
emitstart_value = 0
emitstop_value = 100
life_value = 100
life_variation_value = 0
size_value = 1
size_variation_value = 0
growfor_value = 10
fadefor_value = 10
displayuntil_value = 100

-- Functions

fn dotheupdate o = 
(
	if do_displaycount_value == 1 then 
	(
		o.viewPercent = displaycount_value
	)
	if do_iconsize_value == 1 then 
	(
		o.iconsize = iconsize_value
	)
	if do_birthrate_value == 1 then 
	(
		o.Birth_Rate = birthrate_value
	)
	if do_speed_value == 1 then 
	(
		o.speed = speed_value
	)
	if do_speed_var_value == 1 then 
	(
		o.Speed_Variation = speed_var_value
	)
	if do_emitstart_value == 1 then 
	(
		o.Emitter_Start = emitstart_value
	)
	if do_emitstop_value == 1 then 
	(
		o.Emitter_Stop = emitstop_value
	)
	if do_displayuntil_value == 1 then 
	(
		o.Display_Until = displayuntil_value
	)
	if do_life_value == 1 then 
	(
		o.life = life_value
	)
	if do_life_variation_value == 1 then 
	(
		o.Life_Variation = life_variation_value
	)
	if do_size_value == 1 then 
	(
		o.size = size_value
	)
	if do_size_variation_value == 1 then 
	(
		o.Size_Variation = size_variation_value
	)
	if do_growfor_value == 1 then 
	(
		o.Growth_Time = growfor_value
	)
	if do_fadefor_value == 1 then 
	(
		o.Fade_Time = fadefor_value
	)
	if do_newseed_value == 1 then 
	(
		o.seed = random 0 10000
	)
	if do_facing_value == 1 then 
	(
		o.particleType = 0
		o.standardParticle = 3
	)
	else continue
)

fn pc_chooseobject = 
(
	if emitstart_value > emitstop_value then (MessageBox "Your stop value is less then your start value, please reenter new values" title:"ParticleControl")
	(
		if selection.count == 0 then (MessageBox "Please select at least one object" title:"ParticleControl")
		else
		(
			undo "ParticleControl" on
			(
				for i in selection do
			(
					if standard_particle_filter i == true then
					(
						try (dotheupdate i) catch ()
					)
					else continue
				)
			)
		)
	)
)

-- The Script

rollout pc_rollout "ParticleControl"
(
	group "Display"
(
	checkbox do_displaycount "" across:2
	spinner displaycount_spinner "Display Count %: " range:[0,100,10] fieldWidth:50 enabled:false
	checkbox do_iconsize "" across:2
	spinner iconsize_spinner "Icon Size: " range:[0,10000,50] fieldWidth:50 enabled:false
)
	
	group "Particle Quantity"
(
	checkbox do_birthrate "" across:2
	spinner birthrate_spinner "Birth Rate: " range:[0,10000,10] fieldWidth:50 enabled:false type:#integer
)

	group "Particle Motion"
(
	checkbox do_speed "" across:2
	spinner speed_spinner "Speed: " range:[-99999,99999,10] fieldWidth:50 enabled:false type:#worldunits
	checkbox do_speed_var "" across:2
	spinner speed_var_spinner "Variation %: " range:[0,100,0] fieldWidth:50 enabled:false
)

	group "Particle Timing"
(
	checkbox do_emitstart "" across:2
	spinner emitstart_spinner "Emit Start: " range:[-99999,99999,0] fieldWidth:50 enabled:false type:#integer
	checkbox do_emitstop "" across:2
	spinner emitstop_spinner "Emit Stop: " range:[-99999,99999,100] fieldWidth:50 enabled:false type:#integer
	checkbox do_displayuntil "" across:2
	spinner displayuntil_spinner "Display Until: " range:[-99999,99999,100] fieldWidth:50 enabled:false type:#integer
	checkbox do_life "" across:2
	spinner life_spinner "Life: " range:[0,99999,100] fieldWidth:50 enabled:false type:#integer
	checkbox do_life_variation "" across:2
	spinner life_variation_spinner "Variation: " range:[0,99999,0] fieldWidth:50 enabled:false type:#integer
)

	group "Particle Size"
(
	checkbox do_size "" across:2
	spinner size_spinner "Size: " range:[0,99999,1] fieldWidth:50 enabled:false
	checkbox do_size_variation "" across:2
	spinner size_variation_spinner "Variation %: " range:[0,100,0] fieldWidth:50 enabled:false
	checkbox do_growfor "" across:2
	spinner growfor_spinner "Grow For: " range:[0,99999,10] fieldWidth:50 enabled:false type:#integer
	checkbox do_fadefor "" across:2
	spinner fadefor_spinner "Fade For: " range:[0,99999,10] fieldWidth:50 enabled:false type:#integer
)

	group "Uniqueness"
(
	checkbox do_newseed "" across:2
	label newseed "New Seed" align:#left offset: [-29,0]
)

	group "Particle Type"
(
	checkbox do_facing "" across:2
	label facing "Facing" align:#left offset: [-29,0]
)

	on do_displaycount changed state do 
	(
		displaycount_spinner.enabled = state
		if do_displaycount.checked == true then do_displaycount_value = 1
		else do_displaycount_value = 0
	)
	on displaycount_spinner changed val do displaycount_value = val
	on do_iconsize changed state do 
	(
		iconsize_spinner.enabled = state
		if do_iconsize.checked == true then do_iconsize_value = 1
		else do_iconsize_value = 0
	)
	on iconsize_spinner changed val do iconsize_value = val
	on do_birthrate changed state do 
	(
		birthrate_spinner.enabled = state
		if do_birthrate.checked == true then do_birthrate_value = 1
		else do_birthrate_value = 0
	)
	on birthrate_spinner changed val do birthrate_value = val
	on do_speed changed state do 
	(
		speed_spinner.enabled = state
		if do_speed.checked == true then do_speed_value = 1
		else do_speed_value = 0
	)
	on speed_spinner changed val do speed_value = val
	on do_speed_var changed state do 
	(
		speed_var_spinner.enabled = state
		if do_speed_var.checked == true then do_speed_var_value = 1
		else do_speed_var_value = 0
	)
	on speed_var_spinner changed val do speed_var_value = val
	on do_emitstart changed state do 
	(
		emitstart_spinner.enabled = state
		if do_emitstart.checked == true then do_emitstart_value = 1
		else do_emitstart_value = 0
	)
	on emitstart_spinner changed val do emitstart_value = val
	on do_emitstop changed state do 
	(
		emitstop_spinner.enabled = state
		if do_emitstop.checked == true then do_emitstop_value = 1
		else do_emitstop_value = 0
	)
	on emitstop_spinner changed val do emitstop_value = val
	on do_displayuntil changed state do 
	(
		displayuntil_spinner.enabled = state
		if do_displayuntil.checked == true then do_displayuntil_value = 1
		else do_displayuntil_value = 0
	)
	on displayuntil_spinner changed val do displayuntil_value = val
	on do_life changed state do 
	(
		life_spinner.enabled = state
		if do_life.checked == true then do_life_value = 1
		else do_life_value = 0
	)
	on life_spinner changed val do life_value = val
	on do_life_variation changed state do 
	(
		life_variation_spinner.enabled = state
		if do_life_variation.checked == true then do_life_variation_value = 1
		else do_life_variation_value = 0
	)
	on life_variation_spinner changed val do life_variation_value = val
	on do_size changed state do 
	(
		size_spinner.enabled = state
		if do_size.checked == true then do_size_value = 1
		else do_size_value = 0
	)
	on size_spinner changed val do size_value = val
	on do_size_variation changed state do 
	(
		size_variation_spinner.enabled = state
		if do_size_variation.checked == true then do_size_variation_value = 1
		else do_size_variation_value = 0
	)
	on size_variation_spinner changed val do size_variation_value = val
	on do_growfor changed state do 
	(
		growfor_spinner.enabled = state
		if do_growfor.checked == true then do_growfor_value = 1
		else do_growfor_value = 0
	)
	on growfor_spinner changed val do growfor_value = val
	on do_fadefor changed state do 
	(
		fadefor_spinner.enabled = state
		if do_fadefor.checked == true then do_fadefor_value = 1
		else do_fadefor_value = 0
	)
	on fadefor_spinner changed val do fadefor_value = val
	on do_newseed changed state do 
	(
		if do_newseed.checked == true then do_newseed_value = 1
		else do_newseed_value = 0
	)
	on do_facing changed state do 
	(
		if do_facing.checked == true then do_facing_value = 1
		else do_facing_value = 0
	)

	group "Update Parameters"
	(
		button buttonupdate "Update Parameters" width:150 align:#center toolTip:"Update Parameters"
	)
		on buttonupdate pressed do pc_chooseobject()
)

if pc_floater != undefined then CloseRolloutFloater pc_floater
pc_floater = newRolloutFloater "ParticleControl v1.42" 230 625
addRollout pc_rollout pc_floater
)
-------------------------------------------------------------------------------