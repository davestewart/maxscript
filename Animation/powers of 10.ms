-- Script:	Powers of 10
-- Date:	11 Feb 2006
-- Version:	0.5
-- Author:	Dave Stewart
-- Web:		www.pondskata.com

-- Purpose:	Sets up a camera to travel in a vertical exponential manner, similar to the film "Powers of 10"
-- Usage:	Adjust the variables in the first 3 lines, then run the script to create new objects and animation.


(
-- variables
	pMax = 7	-- how many steps to calculate
	pStep = 10	-- the distance to "power-up" each step
	tStep = 100	-- the length of time (frames) between each step
	
-- functions
	fn pad n len=(n = n as string;while n.count < len do n = "0" + n;return n)

-- objects
	if queryBox "Delete existing objects?" == true then delete objects
	c = freecamera()

-- animation
	animationRange = interval 0 (tStep * (pMax-1))
	for i = 1 to pMax do
	(
		-- variables
			d = (pow pStep i)
			t = (pMax*tStep)- (tStep*i)
			format "time: % | distance: %\n" t d
			
		-- objects
			rectangle width:d length:d name: ("Rectangle " + (pad i 2) + " ("+d as string+")")
			
		-- camera
			k = addNewKey c.position.controller[3].controller t
			k.value = d
			k.inTangentType = #auto
			k.outTangentType = #auto
	
			c.farclip = d
	)

-- setup
	c.showTrajectory = on
	select c
	viewport.activeViewport = 4
	viewport.setType #view_camera

	--slidertime = (tStep * pMax)
	--max tool zoomextents all
	
)