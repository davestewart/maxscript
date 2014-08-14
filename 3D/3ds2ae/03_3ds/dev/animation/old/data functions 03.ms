(
local mxYUP=matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]--XZY
local mxZUP=matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]--XYZ
local coord=#world

	fn round val n:2=
		(
		local p=10^n
		val=floor(val*p)/p
		if abs val < 0.1 then val=0
		return val
		)

	-------------------------------------------------------------------------------
	-- position
		function getPos obj =
			(
		-- data
			local p,x,y,z
			p=obj.pos
			x=(round p.x) as string
			y=(-round p.z) as string
			z=(round p.y) as string
		-- format
			return  "["+x+","+y+","+z+"]"
			)

		function getPos obj =
			(
		-- data
			local p,p3,x,y,z
			p=obj.pos
			p3=Point3 (round p.x) (-round p.z) (round p.y)
		-- format
			return  p3
			)

	-------------------------------------------------------------------------------
	-- rotation
		function getRot obj =
			(
		-- data
			local p,x,y,z
			in coordsys mxYUP r=obj.rotation as eulerangles
			x=round r.x
			y=round r.y
			z=round r.z
		-- format
			return  "["+x+","+y+","+z+"]"
			format "	%	%	%	%\n" f -rx ry rz to:rotData
			)

	-------------------------------------------------------------------------------
	-- scale
		function getScale obj =
			(
		-- data
			sx=round obj.scale.x
			sy=round obj.scale.y
			sz=round obj.scale.z
		-- format
			format "	%	%	%	%\n" f sx sz sy to:scaleData
			)



-------------------------------------------------------------------------------
-- camera data

	-------------------------------------------------------------------------------
	-- FOV
		function getFOV obj =
			(
		-- data
			--fov=round obj.fov
			fov=(spnCompHeight.value/2)/(tan (obj.fov/2))
		-- format
			format "	%	%\n" f fov to:FOVData
			)

-------------------------------------------------------------------------------
-- targetted objects
/*
		if (chkCam.checked OR chkLight.checked) AND obj.target!=undefined then
			(
		-- data
			px=round obj.target.pos.x
			py=round obj.target.pos.y
			pz=round obj.target.pos.z
		-- format
			format "	%	%	%	%\n" f px -pz py to:targData
			)
*/

fn getValues obj start:animationRange.start end:animationRange.end increment:1=
	(
	tStr=stringstream ""
	vStr=stringstream ""

	for t = start to end by increment do
		(
		at time t
			(
			p=obj.pos
			--format "%" ((currenttime as integer) / (4800/framerate)) to:tStr
			format "%" (round(t as float/4800) n:3) to:tStr

			format "[%,%,%]" (round p.x) -(round p.z) (round p.y) to:vStr
			if t<end then
				(
				format "," to:tStr
				format "," to:vStr
				)
			)
		)
	
	return #(tStr,vStr)
	)

(
arr=getValues $ increment:10
format "[%],\n[%]\n" (arr[1] as string) (arr[2] as string)
)



)