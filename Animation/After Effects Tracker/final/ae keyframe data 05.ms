--(

------------------------------------------------------------------------------------------
-- base strings
------------------------------------------------------------------------------------------

local strAEStart = "Adobe After Effects 7.0 Keyframe Data

	Units Per Second	%
	Source Width	%
	Source Height	%
	Source Pixel Aspect Ratio	%
	Comp Pixel Aspect Ratio	%
"

local strAEAnchor = "Transform	Anchor Point
	Frame	X pixels	Y pixels	Z pixels	
%
"

local strAEPosition = "Transform	Position
	Frame	X pixels	Y pixels	Z pixels	
%
"

local strAEDepthMatte = "Effects	Depth Matte #1	Depth #2
	Frame		
%
"

local strAECornerPin = "Effects	Corner Pin #1	Upper Left #2
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

local strAEEnd = "End of Keyframe Data"


------------------------------------------------------------------------------------------
-- functions
------------------------------------------------------------------------------------------

fn getAEStart w h = 
	(
	local str = "" as stringstream
	format strAEStart framerate w h 1 1 to:str
	return str as string
	)
	
fn getAEEnd = 
	(
	return strAEEnd
	)
	
	
fn getAEAnchor obj t1 t2 =
	(
	local p, t
	local strBase	= "" as stringstream
	local strKeys	= "" as stringstream

	if obj == undefined then 
		(
		format "		0	0	0	\n" to: strKeys
		format strAEAnchor (strKeys as string) to:strBase
		return strBase as string
		)
	)

	
fn getAEPosition obj t1 t2 =
	(
	local p, t
	local strBase	= "" as stringstream
	local strKeys	= "" as stringstream

	if obj == undefined then 
		(
		format "		0	0	0	\n" to: strKeys
		format strAEPosition (strKeys as string) to:strBase
		return strBase as string
		)

	local arrPos	= showObjectPath obj
	for t = 1 to arrPos.count do
		(
		p			= arrPos[t]
		format "	%	%	%	0	\n" (t - 1) p.x p.y to: strKeys
		)

	format strAEPosition (strKeys as string) to:strBase
	return strBase as string
	)
	
	
fn getAECornerPin arrTime =
	(
	local p, t
	local strBase	= "" as stringstream
	local strKeys	= "" as stringstream
	
	local arrPos	= #()
	local arrStr	= #()
	local ss		= stringstream ""
	local numVerts	= arrTime[1].count
	
	for v = 1 to numVerts do
		(
		ss = stringstream ""
		for t = 1 to arrTime.count do
			(
			p			= arrTime[t][v]
			format "	%	%	%	\n" (t - 1) p.x p.y to:ss
			)
		append arrStr (ss as string)
		)
	
	format strAECornerPin (arrStr[1]) (arrStr[2]) (arrStr[3]) (arrStr[4]) to:strBase
	return strBase as string
	)
	
fn getAEDepthMatte arrTime =
	(
	local p, t
	local strBase	= stringstream ""
	local strKeys	= stringstream ""
	
	for t = 1 to arrTime.count do
		(
		p			= arrTime[t]
		format "	%	%	\n" (t - 1) p.z to:strKeys
		)
	
	format strAEDepthMatte (strKeys as string) to:strBase
	return strBase as string
	)
	

	
	
	
/*
	clearListener()
	local obj = $
	local t1 = 0
	local t2 = 100
	format "%\n" (getAEStart renderWidth renderHeight)
	format "%\n" (getAEPosition undefined t1 t2)
	format "%\n" (getAEAnchor undefined t1 t2)
	format "%\n" (getAECornerPin obj t1 t2 drawMarkers:true)
	format "%\n" (getAEEnd())
*/
--)