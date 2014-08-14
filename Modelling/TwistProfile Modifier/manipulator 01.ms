

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
	 
		local g = [0, 1, 0], r = [1, 0, 0]
	 
	-- This manipulator manipulates any node with a "radius" property
		on canManipulate target return (findItem (getPropNames target) #twist) != 0
	 
	-- Create the manipulator gizmo.
	-- This is called initially and whenever the manipulator target changes

		local giz
		local val2 = 45
		local arr = #(10,30,100)


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
		
		-- Set the radius of circle gizmo a little bigger than the target radius
		 
			giz = manip.makeCircle [50,0,0] target.twist 28

			print "start"
			for i = 1 to arr.count do
				(
				print i
				y = arr[i]

				giz = manip.makeGizmoShape ()
				
				
				giz.startNewLine()
				giz.addPoint [-20,y,0]
				giz.addPoint [20,y,0]
	
				rotateGizmo giz val2
				
				this.addGizmoShape giz 0 g r 
				
				print (y as string)

				return node.name + " radius = "-- + target.radius as string 
				)

		)
	 
	-- mouseMove is called on every mouse move when dragging the manip
	-- It needs to convert the mouse position 'm' into a new value for the radius
	on mouseMove m which do
		(
		-- Create the XY plane. 
		 
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
				val2 = length projectedPoint
				target.twist = val2 / 1.01
				)
		)
	)
$.transform
