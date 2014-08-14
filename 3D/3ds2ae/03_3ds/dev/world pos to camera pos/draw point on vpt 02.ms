fn drawPointOnVpt x y=
	(
	-- get viewport coords in relation to renderer
		viewSize = point2 (gw.getWinSizeX()) (view_h=gw.getWinSizeY())
		renderSize= point2 (renderWidth*renderPixelAspect ) (renderHeight)
		f=viewSize.x/renderSize.x
		h=ceil (renderSize.y*f/2)*2
		y+=(viewSize.y-h)/2
		
	-- draw the point
		markers=#(#point , #hollowBox , #plusSign , #asterisk , #xMarker , #bigBox , #circle , #triangle , #diamond , #smallHollowBox , #smallCircle , #smallTriangle , #smallDiamond)
		gw.wMarker [x,y,0] #plussign 
	)

-- safe frames
	displaySafeframes=true
	forceCompleteRedraw()
-- draw point	
	drawPointOnVpt 50 50
	gw.enlargeUpdateRect #whole 
	gw.updateScreen() 
