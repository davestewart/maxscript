--------------------------------------------------------------------------
-- Graphing examples using Flash

-- Author:	Dave Stewart
-- Date:	Dec 29 2005
-- www:		www.pondskata.com


destroydialog r1
rollout r1 "Graphing Example 3" width:320 height:336
(

	ActiveXControl ax "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[8,8] width:300 height:300

	--------------------------------------------------------------------------
	-- Interface
	
		label lbl1 "Trajectory:" pos:[8,312] width:56 height:16
		radioButtons rdo1 "" pos:[72,312] width:129 height:16 labels:#("x,y", "x,z", "y,z") columns:3
		button btnNew "New" pos:[188,312] width:120 height:16
	

	--------------------------------------------------------------------------
	-- Variables
	
		-- BE SURE TO UPDATE YOUR FLASH PATH HERE!
		local flashPath	="E:/05 - Scripting/MaxScript/projects/Flash/graphing/"
		local flashFile	="graphing_example_3.swf"

		local plotGraph, createNewAnimation
		local s


	--------------------------------------------------------------------------
	-- Functions
	
		function getPos=
		(
			return [random -100 100,random -100 100,random -100 100]
		)
	
		function createNewAnimation=
		(
			delete objects
			stopAnimation()
			sliderTime=0
			s=sphere()
			s.showTrajectory =on
			
			animationRange = interval 0 (random 25 1000)
			
			with animate on
			(
				for t = animationRange.start to animationRange.end by 25 do
				(
					at time t s.pos=getPos()
				)
			)

			plotGraph()
		)
	
		function plotGraph=
		(
			-- frames
				local framesStr=""
				for t = animationRange.start to animationRange.end do
				(
					case rdo1.state of
					(
						1:		at time t framesStr+=s.pos.x as string + "," + s.pos.y as string + " "
						2:		at time t framesStr+=s.pos.x as string + "," + s.pos.z as string + " "
						3:		at time t framesStr+=s.pos.y as string + "," + s.pos.z as string + " "
						default:	""
					)
				)
				
			-- keys
				local keysStr=""
				local ctrl = s.pos.controller
				for i = 1 to ctrl.keys.count do
				(
					t = ctrl.keys[i].time
					case rdo1.state of
					(
						1:		at time t keysStr+=s.pos.x as string + "," + s.pos.y as string + " "
						2:		at time t keysStr+=s.pos.x as string + "," + s.pos.z as string + " "
						3:		at time t keysStr+=s.pos.y as string + "," + s.pos.z as string + " "
						default:	""
					)
				)
				
			ax.SetVariable "framesStr" framesStr
			ax.SetVariable "keysStr" keysStr
			ax.TCallLabel "_root" "update"
			--messagebox framesStr
		)
		
		function gotoTime k=
		(
			slidertime = s.pos.controller.keys[k].time
			playAnimation()
		)
		
	--------------------------------------------------------------------------
	-- Handlers
	
		on r1 open do
		(
			ax.movie = flashPath+flashFile
			createNewAnimation()
		)
			
		on rdo1 changed state do plotGraph()
		on btnNew pressed do createNewAnimation()
	
		on r1 close do
		(
			stopAnimation()
		)

	on ax FSCommand arg1 arg2 do
	(
		if arg1 == "gotoTime" then gotoTime (arg2 as integer)
	)
	

)

createdialog r1

gc()