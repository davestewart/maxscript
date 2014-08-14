---------------------------------------------------------------------------------------------------
-- Flash Position Control Test
--
-- Author:		Dave Stewart
-- Date:		5th March 2002
-- Version:		0.5
-- MAX:			4.x
--
-- Description:		Sample file to show how Flash can control objects in max by placing an
--					interactive .swf in a rollout.
--
-- Usage:			I've set up the Flash file to send one long string full of commands (separated by
--					spaces), which is then split up by maxscript into an array using the "filterstring".
--					function.
--					This way, you can send many arguments from Flash to max, as opposed to just the
--					"command / argument" pair that Flash FSCommand allows you to.
--
---------------------------------------------------------------------------------------------------

rollout rFlash "Move selected..." width:162 height:252
(


	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------

		-- IMPORTANT!!!!
		-- make sure the next line points to the flash object in your scripts directory...

		local flashFile = "E:/05 - Scripting/MaxScript/projects/Flash/axis control/axis control.swf"
		local args = #()	-- this is the array that will be populated by arguments from the Flash object
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	ActiveXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[13,7] width:150 height:150

	group "Axis"
	(
		radioButtons rdoAxis labels:#("X", "Y", "Z", "XY", "YZ", "ZX") columns:3 align:#left default:4
	)

	group "Effect"
	(
		slider sld1 width:150 height:44 range:[0,1,0.1]
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	-- set the Flash object
		on rFlash open do
		( 
			axFlash.movie = flashFile  
			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
			rdoAxis.state = 4
		)


	-- receive Flash commands
		on axFlash FSCommand str1 str2 do
		( 
			args = filterString str1 " "
			arg1 = (args[1] as float) * sld1.value
			arg2 = -(args[2] as float) * sld1.value -- Flash coordinate system is the opposite in y

			if selection.count > 0 then
			(
				for obj in selection do
					try (
						case rdoAxis.state of
						(
							1: obj.pos +=[arg1,0,0]
							2: obj.pos +=[0,arg2,0]
							3: obj.pos +=[0,0,arg2]
							4: obj.pos +=[arg1,arg2,0]
							5: obj.pos +=[0,arg2,arg1]
							6: obj.pos +=[arg1,0,arg2]
						)
					)
					catch()
			)
		)

)
if flashFloater != undefined then closerolloutfloater flashFloater
	flashFloater = newRolloutFloater "Flash Floater" 200 350
addRollout rFlash flashFloater
