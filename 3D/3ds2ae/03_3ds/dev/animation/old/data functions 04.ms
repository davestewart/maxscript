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
		fn getPos obj =
			(
			local v=obj.pos
			local p3=Point3 (round v.x) (-round v.z) (round v.y)
			return p3
			)

	-------------------------------------------------------------------------------
	-- rotation
		fn getRot obj =
			(
			in coordsys mxYUP local v=obj.rotation as eulerangles
			local p3=Point3 (round -v.x) (round v.y) (round v.z)
			return p3
			)

	-------------------------------------------------------------------------------
	-- scale
		fn getScale obj =
			(
			local v=obj.scale
			local p3=Point3 (round v.x) (round v.z) (round v.y)
			return p3
			)



-------------------------------------------------------------------------------
-- camera data

	-------------------------------------------------------------------------------
	-- FOV
		fn getCamZoom obj h:600=
			(
			local fov=round ((h.value/2)/(tan (obj.fov/2)))
			return fov
			)

		fn getLightIntensity obj =
			(
			)
			
		fn getLightConeAngle obj =
			(
			)
			
		fn getLightConeFeather obj =
			(
			)
			
		fn getColor obj =
			(
			)
			
		fn getTime obj =
			(
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