fn pad strStr strPad:"0" length:2 =
	(
	strStr = strStr as string
	while strStr.count < length do strStr = strPad + strStr
	return strStr
	)
	
	
--str = pad 5
--str = pad 500 length:20 strPad:"-"

