-- Draw some primitives 



fn drawPointOnVpt x y=
(
	-- get view
		viewSize = point2 (gw.getWinSizeX()) (view_h=gw.getWinSizeY())
		renderSize= point2 (renderWidth*renderPixelAspect ) (renderHeight)
		
		f=viewSize.x/renderSize.x
		renderSize*f
)


gw.hPolyline #([0,0,0], [50,50,50], [450,250,4]) true 

gw.polyline #([0,0,0], [50,50,50], [450,250,4]) true 

gw.wMarker [0,0,0] #plussign 


/*
#point 
#hollowBox 
#plusSign 
#asterisk 
#xMarker 
#bigBox 
#circle 
#triangle 
#diamond 
#smallHollowBox 
#smallCircle 
#smallTriangle 
#smallDiamond 
*/
-- 
/*
gw.hPolygon #([200,100,16], [280,100,8], [250,200,4]) \ 

            #(red, blue, green) \ 

            #([1.0,.5,0], [0.5,0.5,0], [0,0,0.5]) 

-- 

gw.hTriStrip #([50,50,0], [175,100,0], [25,100,0], [150,250,0]) \ 

             #(red, blue, green, white) \ 

             #([1.0,.5,0], [0.5,0.5,0], [0,0,0.5], [0.5,1,0]) 

-- 
*/
-- Update the viewports 

gw.enlargeUpdateRect #whole 

gw.updateScreen() 
