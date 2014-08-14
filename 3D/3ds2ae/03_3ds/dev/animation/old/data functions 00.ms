(
	local mxYUP=matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]--XZY
	local mxZUP=matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]--XYZ
	local mxYUP=matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]

	fn trimFloat val n=
	(
		p=10^n
		return ceil(val*p)/p
	)
		
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
				format "%" (t as float/4800) to:tStr
	
				format "[%,%,%]" (trimFloat p.x 2) -(trimFloat p.z 2) (trimFloat p.y 2) to:vStr
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
