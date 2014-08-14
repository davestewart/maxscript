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
		local v, p, pMin, pMax, rgn
		local m	= snapshotasmesh obj
		
	-- initialize region
		v		= getvert m 1
		p		= gw.transPoint v
		p		= point2 p.x p.y
		rgn		= box2 p.x p.y 0 0
		numVerts=getnumverts m
		
	-- check rest of region
		for i = 2 to numVerts do
	(
			v		= getvert m i
			p		= gw.transPoint v
			p		= point2 p.x p.y
			
			print p
			
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
)

--viewport.setRegionRect viewport.activeViewport (getMeshRegion $)

getMeshRegion $
/*
		pMin	= point2 p.x p.y
		pMax	= point2 p.x p.y

*/