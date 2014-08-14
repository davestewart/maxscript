---------------------------------------------------------------------------------------------------
-- Flash Position Control Test
--
-- Author:		Dave Stewart
-- Date:		8th June 2007
-- Version:		0.5
-- MAX:			4.x
--
-- Description:		Sample file to show how Flash can control objects in max by placing an
--					interactive .swf in a rollout.
--
-- Usage:			I've set up the Flash file to send one long string full of commands (separated by
--					commas), which is then split up by maxscript into an array using the "filterstring".
--					function.
--					This way, you can send many arguments from Flash to max, as opposed to just the
--					"command / argument" pair that Flash FSCommand allows you to.
--
---------------------------------------------------------------------------------------------------

rollout roFlash "Move selected..." width:162 height:272
(


	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

		-- IMPORTANT!!!!
		-- make sure the next line points to the flash object in your scripts directory...

		local flashFile = getDir #scripts + "\\Flash\\axisControl.swf"
		local flashFile = "E:\\03_Scripting\\maxScript\\max 9\\realtime animation\\Flash AxisControl\\axisControl.swf"

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	
	ActiveXControl axFlash "ShockwaveFlash.ShockwaveFlash.9" pos:[13,7] width:150 height:150

	-- If the Flash doesn't load, it's probably because you don't have the correct Class ID or Program ID.
	-- Get the Flash ID string by running this command: showallactivexcontrols to:(newscript()) and searching for "Flash"
	
	-- "Shockwave Flash Object"
	-- "ShockwaveFlash.ShockwaveFlash.9"
	-- "{D27CDB6E-AE6D-11CF-96B8-444553540000}" 

	group "Flash Variables"
		(
		spinner spnSlowdown "slowdown " range:[0, 1, 0.9] type:#float
		)

	group "Axis"
		(
		radioButtons rdoAxis labels:#("X", "Y", "Z", "XY", "YZ", "ZX") columns:3 align:#left default:4
		)

	group "Effect"
		(
		slider sld1 width:150 height:44 range:[0,100,25]
		)


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	-- set the Flash object
		on roFlash open do
			( 
			axFlash.movie = flashFile  
			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
			rdoAxis.state = 4
			s = sphere isSelected:true
			)


	-- receive Flash commands
		on axFlash FSCommand str1 str2 do
			(
			-- get the FSCommand argument and split it up
				local args = filterString str1 ","
				local v1 = (args[1] as float) * sld1.value
				local v2 = (args[2] as float) * sld1.value

			
			-- do something with the data
				if selection.count > 0 then
					(
					for obj in selection do
						try (
							case rdoAxis.state of
								(
								1: obj.pos +=[v1, 0, 0]
								2: obj.pos +=[0, v2, 0]
								3: obj.pos +=[0, 0, v2]
								4: obj.pos +=[v1, v2, 0]
								5: obj.pos +=[0, v2, v1]
								6: obj.pos +=[v1, 0, v2]
								)
							)
						catch()
					)
			)
			
		on spnSlowdown changed val do axFlash.setVariable "slowdown" val

)
if flashFloater != undefined then closerolloutfloater flashFloater
flashFloater = newRolloutFloater "Flash Floater" 200 365
addRollout roFlash flashFloater
