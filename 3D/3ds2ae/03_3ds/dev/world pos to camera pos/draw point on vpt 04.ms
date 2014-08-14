fn getVptSafeFrame=
(
)

fn drawPointOnVpt x y =
(
	-- get viewport coords in relation to renderer
		viewSize	= point2 (gw.getWinSizeX()) (view_h=gw.getWinSizeY())
		renderSize	= point2 (renderWidth*renderPixelAspect ) (renderHeight)
		f			= viewSize.x/renderSize.x
		h			= ceil (renderSize.y*f/2)*2
		top			= (viewSize.y-h)/2
		--print top
	-- transform x and y
		x			*= f	--*renderPixelAspect 
		y			= y*f	--*renderPixelAspect
		y			+= top
		
	-- draw the point
		markers		=#(#point , #hollowBox , #plusSign , #asterisk , #xMarker , #bigBox , #circle , #triangle , #diamond , #smallHollowBox , #smallCircle , #smallTriangle , #smallDiamond)
		gw.wMarker [x,y,0] #xMarker color:(color 0 255 0)
)

-- safe frames
	if viewport.GetType()==#view_camera then
	(
		displaySafeframes=true
		forceCompleteRedraw()
	)
-- draw point	
	drawPointOnVpt 50 50
	gw.enlargeUpdateRect #whole 
	gw.updateScreen() 

/*
-- must add in proper transfor when viewport is higher than wider
--and for when safe frames are on or off, as this affects how much of the display is shown.

-- is there any possibility of using a matrix to transform all the points?

viewsize.x/viewsize.y
rendersize.x/rendersize.y
*/

