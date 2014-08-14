

--------------------------------------------------------------------
-- Generic radius manipulator
-- Written by Scott Morrison
 
-- This manipulator sets the radius on any object or modifier with
-- a parameter named "radius". It creates a circle gizmo of the appropriate
-- radius centered at the origin in the XY plane.
 
plugin simpleManipulator twistManip2
name:"RadiusManip2"
invisible:true
(
	-- Create the green and red colors for the gizmo
	 
		local green = [0, 1, 0], red = [1, 0, 0]
	 
	-- This manipulator manipulates any node with a "radius" property
		on canManipulate target return (findItem (getPropNames target) #twist) != 0
	 
	-- Create the manipulator gizmo.
	-- This is called initially and whenever the manipulator target changes

		local giz
		local currentManip = 1
		
		local arrPos = #(10,30,100)
		local arrRot = #(10,30,100)

		function rotateGizmo giz val =
		(
			local mx = matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]
			rotateY mx val
			giz.transform mx
		)
			
	on updateGizmos do
	(
		-- Clear the current gizmo cache
			this.clearGizmos()
		
		-- Build new gizmos

			for i = 1 to arrPos.count do
			(
				print i
				y = arrPos[i]
				r = arrRot[i]
				
				giz = manip.makeGizmoShape ()
				
				giz.startNewLine()
				giz.addPoint [-20,y,0]
				giz.addPoint [20,y,0]
	
	
				--if (currentManip + 1) == i then 
				rotateGizmo giz r
				
				this.addGizmoShape giz 0 green red
			)

			return node.name + "Current Gizmo = " + (currentManip + 1) as string + " " + arrRot as string

	)
	 
	-- mouseMove is called on every mouse move when dragging the manip
	-- It needs to convert the mouse position 'm' into a new value for the radius
	
	on mouseMove m which do
	(
		-- Create the XY plane. 
		
		currentManip = which
		 
		-- manip.makePlaneFromNormal takes a normal vector and a point
		-- and creates a plane passing through the point with the given normal
			local pl				= manip.makePlaneFromNormal z_axis [0, 0, 0]
			local projectedPoint	= [0,0,0]
			 
		-- Compute the hit-ray in local coordinates
			viewRay					= this.getLocalViewRay m
		 
		-- Intersect the plane with the view ray
			res						= pl.intersect viewRay &projectedPoint
		
		-- If the intersection worked, set the radius
		 
			if (res) then
			(
				val = length projectedPoint
				target.twist = val
				arrRot[currentManip + 1] = val
			)
	)
)
$.transform
