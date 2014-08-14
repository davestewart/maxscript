	fn round val=
		(
		local n=1
		local p=10^n
		val=floor(val*p)/p
		if abs val < 0.1 then val=0
		return val
		)

	-------------------------------------------------------------------------------
	-- position
		function getPos =
			(
		-- data
			px=getVal obj.pos.x
			py=getVal obj.pos.y
			pz=getVal obj.pos.z
		-- format
			format "	%	%	%	%\n" f px -pz py to:posData
			)

	-------------------------------------------------------------------------------
	-- rotation
		function getRot=
			(
		-- data
			in coordsys mxYUP rot=obj.rotation as eulerangles
			rx=getVal rot.x
			ry=getVal rot.y
			rz=getVal rot.z
		-- format
			format "	%	%	%	%\n" f -rx ry rz to:rotData
			)

	-------------------------------------------------------------------------------
	-- scale
		function getScale=
			(
		-- data
			sx=getVal obj.scale.x
			sy=getVal obj.scale.y
			sz=getVal obj.scale.z
		-- format
			format "	%	%	%	%\n" f sx sz sy to:scaleData
			)

-------------------------------------------------------------------------------
-- camera data

	-------------------------------------------------------------------------------
	-- FOV
		function getFOV=
			(
		-- data
			--fov=getVal obj.fov
			fov=(spnCompHeight.value/2)/(tan (obj.fov/2))
		-- format
			format "	%	%\n" f fov to:FOVData
			)

-------------------------------------------------------------------------------
-- targetted objects

		if (chkCam.checked OR chkLight.checked) AND obj.target!=undefined then
			(
		-- data
			px=getVal obj.target.pos.x
			py=getVal obj.target.pos.y
			pz=getVal obj.target.pos.z
		-- format
			format "	%	%	%	%\n" f px -pz py to:targData
			)

