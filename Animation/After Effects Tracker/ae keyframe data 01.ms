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
	
fn getKeyPosition arr t =
	(
	local strBase	= "" as stringstream
	local strKeys	= "" as stringstream
	for a in arr do
		(
		format "	%	%	%	%	\n" t a[1] a[2] a[3] to: strKeys
		t += 1
		)
	format aeKeyPosition (strKeys as string) to:strBase
	return strBase as string
	)
	
if testing != false then
	(
	clearListener()
	local arrPos = for i = 1 to 10 collect at time i $.pos
	format "%\n" (getKeyStart 300 300)
	format "%\n" (getKeyPosition arrPos 1)
	format "%\n" (getKeyEnd())
	)
)