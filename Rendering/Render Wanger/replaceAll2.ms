str = "c:/temp/hello"
outStr = "/"
inStr="###"
str
replaceAll str "/" "###"

	fn replaceAll str outStr inStr =
	(
		str = #(str,"")

		while findstring str[1] outStr != undefined do
		(
		-- get variables
			s1 = 1
			s2 = (findstring str[1] outStr) + (-1)
			s3 = (findstring str[1] outStr) + outStr.count

		-- build str[2]
			str[2]+= substring str[1] s1 s2
			str[2]+= inStr
			
		-- reduce str[1]
			str[1]= substring str[1] s3 str[1].count
		)
		str[2]+=str[1]
		return str[2]
		)