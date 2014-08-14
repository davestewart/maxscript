(
local aeKeyStart = "Adobe After Effects 7.0 Keyframe Data

	Units Per Second	%
	Source Width	%
	Source Height	%
	Source Pixel Aspect Ratio	%
	Comp Pixel Aspect Ratio	%
"

local aeKeyAnchor = "Transform	Anchor Point
	Frame	X pixels	Y pixels	Z pixels	
%
"

local aeKeyPosition = "Transform	Position
	Frame	X pixels	Y pixels	Z pixels	
%
"

local aeKeyCornerPin = "Effects	Corner Pin #1	Upper Left #2
	Frame	X pixels	Y pixels	
%	

Effects	Corner Pin #1	Upper Right #3
	Frame	X pixels	Y pixels	
%

Effects	Corner Pin #1	Lower Left #4
	Frame	X pixels	Y pixels	
%

Effects	Corner Pin #1	Lower Right #5
	Frame	X pixels	Y pixels	
%
"

local aeKeyEnd = "End of Keyframe Data"


fn getKeyStart w h = 
	(
	local str = "" as stringstream
	format aeKeyStart framerate w h 1 1 to:str
	return str as string
	)
	
fn getKeyEnd = 
	(
	return aeKeyEnd
	)
	
fn getKeyPosition obj t1 t2 drawMarkers:false =
	(
	local p, t, a
	local strBase	= "" as stringstream
	local strKeys	= "" as stringstream
	
	gw.setTransform(Matrix3 1)

	for t = t1 to t2 do
		(
		p			= at time t getScreenPos obj
		format "	%	%	%	0	\n" t p.x p.y to: strKeys
		t			+= 1
		if drawMarkers == true then gw.wMarker p #circle color:green
		)

	if drawMarkers == true then
		(
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
		)


	format aeKeyPosition (strKeys as string) to:strBase
	return strBase as string
	)
	
if testing != false then
	(
	clearListener()
	format "%\n" (getKeyStart 300 300)
	format "%\n" (getKeyPosition $ 1 40 drawMarkers:true)
	format "%\n" (getKeyEnd())
	)
)