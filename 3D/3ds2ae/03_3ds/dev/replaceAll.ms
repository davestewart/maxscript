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

fn checkName str=
	(
	if findstring str "'" != undefined then str=replaceAll str "'" "\'"
	return str
	)

checkName "hello 'dave'"