-- variables

	
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
				if p.x < rgn.left then rgn.left = p.x
				else if p.x > rgn.right do rgn.right = p.x
				
				if p.y < rgn.top then rgn.top = p.y
				else if p.y > rgn.bottom do rgn.bottom = p.y
			)
		)	
		
	-- return
		rgn
		
	)
	
	
	function getMeshRegion obj =	
	(
	-- setup
		gw.setTransform(Matrix3 1)

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
			p		= point2 p.x p.y
			append arr p
		)		
		
	-- return
		arrayToBox2 arr
	)

function viewportRegionFromGWRegion rgnIn =
(
	local vpt	= getViewSize()
	local rnd	= point2 (renderwidth * renderPixelAspect) renderheight
	--rgn = getMeshRegion $
	local scl	= rnd / vpt
	local rgn	= box2 0 0 1 1
	
	rgn.left	= rgnIn.left * scl.x
	rgn.right	= rgnIn.right * scl.x
	rgn.top		= rgnIn.top * scl.y
	rgn.bottom	= rgnIn.bottom * scl.y
	
	rgn
)

rgn		= getMeshRegion $ 
rgn2	= viewportRegionFromGWRegion rgn

viewport.setRegionRect viewport.activeViewport rgn2

/*
		pMin	= point2 p.x p.y
		pMax	= point2 p.x p.y


arr = #(
	[10,50], 
	[200,300]
)

*/