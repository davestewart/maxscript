fn getAppAE=
(
	local fStr=getopenfilename caption:"Select After Effects application file (AfterFX.exe)..." types:"Application (*.exe)|AfterFX.exe"
	if fStr==undefined then return undefined
	else if (findstring fStr "AfterFX.exe" != undefined) AND (doesFileExist fStr) then return fStr
	else return undefined
)


fn replaceAll str outStr inStr=
(
	for i = str.count to 1 by -1 do
	(
		if str[i]==outStr then
		(
			local beg=substring str 1 (i-1)
			local end=substring str (i+1) -1
			str=beg+inStr+end
		)
	)
	return str
)


fn escapeString str=
(
	if classof str == String then
	(
		if findstring str "'" != undefined then str=replaceAll str "'" "\'"
	)
	return str
)


fn round v n:2=
(
	if superclassof v == Number then
	(
		local p=10.0^n
		v=(floor ((v * p) + 0.5)) / p
		if (v as Integer) - (v as Float)==0 then return v as integer
		else return v as float
	)
	else if classof v == point3 then
	(
		v.x=round v.x n:n
		v.y=round v.y n:n
		v.z=round v.z n:n
		return v
	)
	else if classof v == point2 then
	(
		v.x=round v.x n:n
		v.y=round v.y n:n
		return v
	)
)


fn getName obj=
(
	return escapeString obj.name
)


fn getParentName obj=
(
	if obj.parent==undefined then return undefined
	else return escapeString obj.parent.name
)
