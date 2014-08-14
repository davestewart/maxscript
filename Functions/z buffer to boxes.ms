delete geometry
for i = 1 to 10 do sphere radius:(random 5 50) pos:[random -100 100,random -100 100,random -20 20]
max tool zoomextents

bm = bitmap 100 100 channels:#(#zDepth)
r = render to:bm

delete geometry

res = 2
maxH=800

with redraw off
(
	for x = 0 to bm.width-1 by res do
	(
		for y = 0 to bm.height-1  by res do
		(
			h = (getChannel bm [x,y] #zDepth)
			print h
			if h[1] != -1e+030 then
			(
				h=maxH + h[1]
				box width:res length:res height:h pos:[x,y,0] wirecolor:white
			)
			
		)
	)
)
forceCompleteRedraw()
/*
getChannel bm [0,0] #zDepth

bm.width

*/

