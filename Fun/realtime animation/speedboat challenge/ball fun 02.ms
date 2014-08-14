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

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	
		ActiveXControl axFlash "ShockwaveFlash.ShockwaveFlash.9" pos:[13,7] width:150 height:150
		group "Controls"
		(
			checkbutton chkActive "Active" across:2
			button btnClose "Close"
			timer tmr1 "Timer" pos:[8,112] width:24 height:24 interval:(1000 / 25)
		)

	---------------------------------------------------------------------------------------------------
	-- variables
	---------------------------------------------------------------------------------------------------
	
		local animateObjects
		local vx = 0, vy = 0, vz = 0
		local pz	= 0
		local g		= -3.0
		local f		= 0.97
		local pc	= 0
		local p, c, d, s
		
		local fps	= 25
		
		local sp	= point3 0 0 0
		local spOld	= point3 0 0 0
		
		
	---------------------------------------------------------------------------------------------------
	-- functions
	---------------------------------------------------------------------------------------------------
	
		fn loadFlash =
		(
			local flashFile = getDir #scripts + "\\Flash\\axisControl.swf"
			local flashFile = "E:\\03_Scripting\\maxScript\\max 9\\realtime animation\\Flash AxisControl\\axisControl.swf"
			axFlash.movie = flashFile  
			axFlash.movie = flashFile  -- need to load 2nd time sometimes 
		)
	
		fn getSurface src trg =
		( 
			r1	= ray (src.pos + [0,0,10000]) [0,0,-1] 
			r2	= intersectRay trg r1
			z	= if r2 == undefined then 0 else r2.pos.z
			z
		)
		
		fn moveToSurface src trg =
		( 
			src.pos.z = getSurface src trg
		)
	
		function setup =
		(
			
				tmr1.interval = 1000 / fps
			
			-- delete Objects
				--delete objects
				for o in objects do if o.name != "ground" do delete o
				
			-- create objects
				--p = plane width:1000 length:1000 widthsegs:50 lengthsegs:50 isselected:true
				p = $ground
				--addmodifier p (noisemodifier strength:[0,0,50])
				
				/*
				c = circle radius:400 pos:[0,0,100]
				d = dummy()
				local pc = Path_Constraint ()
				d.pos.controller = pc
				pc.appendTarget c 100
				*/
				s = sphere()
				s.recenter = on
				s.pos.z = 300
		)
			
		function animateObjects =
		(
			-- sphere horz
				s.pos.x += vx * 20
				s.pos.y += vy * 20
	
			-- sphere vert
				pz		= getSurface s p
				
				if s.pos.z <= pz then
				(
					s.pos.z	= pz
					vz		= 0
					vz		= s.pos.z - pz
					--s.pos.z	+= vz
				)
				else
				(
					vz		+= g
					s.pos.z	+= vz
				)
					
			-- store vertical velocity
		)
			
		function cleanup = 
		(
			tmr1.active = false
			try(
				for obj in arrObj do delete obj
			)
			catch(err)
			--delete objects
		)
		
	
	
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	-- set the Flash object
		on roFlash open do
		(
			loadFlash()
			setup()
		)

	-- receive Flash commands
		on axFlash FSCommand str1 str2 do
		(
			local args = filterString str1 ","
			vx = args[1] as float
			vy = args[2] as float
		)
			
	-- other
		on roFlash close do cleanup()
		
		on btnClose pressed do
		(
			destroydialog roFlash
		)
		
		on tmr1 tick  do
		(
			if chkActive.checked do animateObjects ()
		)
	)
if flashFloater != undefined then closerolloutfloater flashFloater
flashFloater = newRolloutFloater "Flash Floater" 200 365
addRollout roFlash flashFloater
