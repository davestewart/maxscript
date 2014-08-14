(
-- variables

-- setup
	gw.setTransform(Matrix3 1)

	
-- functions
	
	function arrayToBox2 arr =
	(
	-- variables
		local p 
		local rgn = box2 arr[1].x arr[1].y 0 0
		
	-- code
		for i = 2 to arr.count do
		(
			p	= arr[i]
			if NOT contains rgn p do
			(
				if p.x < rgn.x then rgn.x = floor p.x
				else if p.x > rgn.x + rgn.w do rgn.w = ceil (p.x - rgn.x)
				
				if p.y < rgn.y then rgn.y = floor p.y
				else if p.y > rgn.y + rgn.h do rgn.h = ceil (p.y - rgn.y)
			)
		)	
		
	-- return
		rgn
		
	)
	
	
	function getMeshRegion obj =	
	(
	-- variables
		local v, p
		local m		= snapshotasmesh obj
		local arr	= #()
		local vts	= getnumverts m
		
	-- check rest of region
		for i = 1 to vts do
		(
			v		= getvert m i
			p		= gw.transPoint v
			append arr (point2 p.x p.y)
		)		
		
	-- return
		arrayToBox2 arr
	)
)

--viewport.setRegionRect viewport.activeViewport (getMeshRegion $)

getMeshRegion $
/*
		pMin	= point2 p.x p.y
		pMax	= point2 p.x p.y


arr = #(
	[10,50], 
	[200,300]
)

*/