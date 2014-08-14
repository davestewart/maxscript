str = "c:/temp/hello"


	fn replaceAll str outStr inStr =
	(
		str = #("",str)

		for i = 1 to (strArr[2].count) do
		(
			try(
				i = findstring str[2] outStr
				print i
				str[1]+= (substring str[2] 1 i) + inStr			-- put left bit in strArr[1]
				str[2]= substring str[2] (outStr.count + 1) str[2].count		-- delete outString from satArr[2]

			)
			catch
			(
				print str[1]
			)
		)
	)
