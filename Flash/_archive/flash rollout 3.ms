rollout rFlash "Shockwave Flash Object" width:162 height:252
(
	---------------------------------------------------------------------------------------------------
	-- local declarations
	---------------------------------------------------------------------------------------------------
		local flashFile = "D:\\Design\\1 - 3D\\3dsmax4\\scripts\\new\\flash testing\\button.swf"
	
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
		ActiveXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[13,7] width:200 height:200 
		slider sld1 "Multiplier: 1                      " pos:[16,216] width:200 height:44 range:[0,1,1]

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	-- set the Flash object
		on rFlash open do
			( 
			axFlash.movie = flashFile  
			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
			)

		on axFlash OnReadyStateChange arg1 do format "handler: OnReadyStateChange : % %\n" arg1 arg2
		on axFlash OnProgress arg1 do format "handler: OnProgress : % 5\n" arg1 arg2

		on axFlash FSCommand arg1 arg2 do
			( 
			arg1 = (arg1 as float) * sld1.value
			arg2 = -(arg2 as float) * sld1.value -- Flash coordinate system is the opposite in y

			if selection.count > 0 then
				(
				for obj in selection do
					try (obj.pos +=[arg1,arg2,0])
					catch()
				)
			)

		on sld1 changed val do
			(
			str = "Multiplier: " + val as string
			sld1.caption = str
			)
)
if flashFloater != undefined then closerolloutfloater flashFloater
	flashFloater = newRolloutFloater "Flash Floater" 250 330
addRollout rFlash flashFloater
