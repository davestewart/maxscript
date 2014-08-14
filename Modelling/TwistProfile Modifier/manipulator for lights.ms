/*
/////////////////////////////////////////////////////////////////////////
Scripted Manipulator 

Created: April 7 2002 - Pierre-Felix Breton
Version: 0.1 (scripted plugin)

Purpose:

This manipulator is intended to provide quick and fast roll angle access features for targeted lights
that are within luminaires or not.

Abstract:

a)A gizmo is drawn between a light object and it's target.

b)The Gizmo is made of one circle and 2 lines displaying the local
  x and y axis of the light.

c)As the mouse is clicked and dragged on the circle, we allow free rotation of the light (roll angle)

d)if the user click on an axis line or a dot, the light flip by +/- 90 degrees.
  This is for fast flipping.
  
e) The Gizmo calculates its size based on the viewport zoom factor (resizes itself only when redrawn)
 
 
Revision history:

August 22 2002: Initial implementation.

June 16 2003: Fixed script failure when a user cancles the light creation


/////////////////////////////////////////////////////////////////////////
*/

plugin simpleManipulator Light_RollAngle_Manipulator
name:"Light Roll Angle Manipulator"
invisible:true

(--plugin begin
	-- Create the green and red colors for the gizmo 

	--******************************************************************************************
	--Variable definitions
	--******************************************************************************************

	-- gizmo shape related
	local clrGizmoBaseClr = [0.8,0.8,0]
	local clrGizmoActiveClr = [1,1,0]
	local clrGizmoRed = [1,0,0]
	local clrGizmoGreen = [0,1,0]
	local clrGizmoBlue = [0,0,1]
	local fltNonScalingObjectsSize = gw.NonScalingObjectSize() --counter weight the zoom factor of the screen, user preference
	
	
	--rotation related
	local MouseDownRollAngle = 0
	local MouseDownIntersectionPoint = [0,0,0]
	local MouseDownVportCoords = [0,0]
	local nodeRoll = 0
	
	 
	--******************************************************************************************
	--Functions
	--******************************************************************************************
	
	-- Sends a roll angle in degrees and rescales it back to
	--be within a 0-360 range
	fn NormalizeRollAngle angle =
	(
		angle = mod angle 360

	)
	
	
	--******************************************************************************************
	--Events
	--******************************************************************************************

	-- Filter
	
	on canManipulateNode n do((Superclassof n == Light) and (n.target != undefined))	
	
	-- Create the manipulator gizmo. 
	-- This is called initially and whenever the manipulator target changes 
	on updateGizmos do 
	( 
	
		local giz
		local gizpos = [0,0,0]
		local TM = (matrix3 [25,0,0] [0,25,0] [0,0,1] [0,0,0])
		local fltDistanceFromTarget = 0 --distance between target and gizmo
		local wrldGizDiam = 10 --gizmo diameter variable
		local lblToolTip = ""
		
		-- Clear the current gizmo cache 
		this.clearGizmos() 
		
		if node.target != undefined do --pfb; 16 juin 2003: fixes cases wher a light can be set to targeted/non-targeted
		(		
			-- defines gizmo distance to position it on the line between the light and the target
			--due to Maxscript inconsistencies, the target_distance property is not always valid
			if node.targetdistance == undefined 
				then fltDistanceFromTarget = node.target_distance
				else fltDistanceFromTarget = distance node node.target --pfb;June 16 2003
	
			gizpos = [0,0,-fltDistanceFromTarget/2] --positions the gizmo between the target and the node (-z coord)
			wrldGizDiam = (getscreenscalefactor gizpos) * fltNonScalingObjectsSize /10  --defines the gizmo diameter based on the screen scale factor.
			
			--///////////////////////////////////////
			--Gizmo 0 : circle
			--///////////////////////////////////////
			giz = manip.makeCircle [0,0,gizpos.z] (wrldGizDiam/1.25) 18
			this.addGizmoShape giz gizmoActiveViewportOnly clrGizmoBlue clrGizmoActiveClr	
	
	
			--///////////////////////////////////////
			--Gizmo 1 : green axis (y)
			--///////////////////////////////////////
			-- defines the flipping dots and axis lines
			giz = manip.makeGizmoShape()
			giz.addpoint [0,0,gizpos.z]
			giz.addpoint [0,wrldGizDiam,gizpos.z]
			this.addGizmoShape giz gizmoActiveViewportOnly clrGizmoGreen clrGizmoActiveClr	
			
			--///////////////////////////////////////
			--Gizmo 2: red axis (x)
			--///////////////////////////////////////
			giz = manip.makeGizmoShape()
			giz.addpoint [0,0,gizpos.z]
			giz.addpoint [wrldGizDiam,0,gizpos.z]
		    this.addGizmoShape giz gizmoActiveViewportOnly clrGizmoRed clrGizmoActiveClr	
			
			--///////////////////////////////////////
			--Gizmo 3
			--///////////////////////////////////////
			this.addGizmoMarker #diamond [0,wrldGizDiam,gizpos.z] gizmoActiveViewportOnly clrGizmoGreen clrGizmoActiveClr
			--///////////////////////////////////////
			--Gizmo 4
			--///////////////////////////////////////
			this.addGizmoMarker #diamond [wrldGizDiam,0,gizpos.z] gizmoActiveViewportOnly clrGizmoRed clrGizmoActiveClr
	
			--///////////////////////////////////////
			--Gizmo 5
			--///////////////////////////////////////
			--adds a small circle in the insertion point of the gizmo
			this.addGizmoMarker #smallcircle gizpos gizmoActiveViewportOnly clrGizmoBlue clrGizmoActiveClr
			
			-- return the ToolTip string 
			lblToolTip = ("Roll Angle: " + (node.transform.controller.roll_angle as string)) --end update gizmos
			
		)--end if node.target != undefined 
		
	)--end updateGizmos

	--Mouse down event
	--Stores the current rotation and projected point to calculate the rotation
	-- during dragging (mouse move)
	on mouseDown m wich do
	(
		MouseDownVportCoords = (m) 
		MouseDownRollAngle = NormalizeRollAngle (node.transform.controller.roll_angle) -- cache the current roll angle of the light	
		node.transform.controller.roll_angle  = MouseDownRollAngle 
		
		-- the circle and arrows
		if wich == 0 do 
		(
		)
		
		-- the Y+ line
		if wich == 1 do 
		(
			node.transform.controller.roll_angle = node.transform.controller.roll_angle + 90
		)
		
		--the x+ line
		if wich == 2 do 
		(
			node.transform.controller.roll_angle = node.transform.controller.roll_angle - 90
		)
		
		-- the Y+ dot
		if wich == 3 do 
		(
			node.transform.controller.roll_angle = node.transform.controller.roll_angle + 90
		)
		
		--the x+ dot
		if wich == 4 do 
		(
			node.transform.controller.roll_angle = node.transform.controller.roll_angle - 90
		)
		
		--the small cercle
		if wich == 5 do 
		(
			
		)
	
	)--end mouse down


	-- Mouse move event
	on mouseMove m which do 
	(  
		--ony if the circle and arrows are dragged
		--rotates the light through it's roll angle
		if (which == 0 or which == 5) do
		(
			--calculates the mouse movement in Y screen coords 
			local DeltaRoll = (MouseDownVportCoords.y - m.y) 
				
			--updates the node roll angle
			node.transform.controller.roll_angle = (DeltaRoll + MouseDownRollAngle)
		)
	) --end on mouse move


	-- Mouse Up event
	on mouseUp m wich do
	(
		node.transform.controller.roll_angle =  NormalizeRollAngle (node.transform.controller.roll_angle)
	)--end mouse up

	
) --end plugin
-------------------------------------------------------------------- 
