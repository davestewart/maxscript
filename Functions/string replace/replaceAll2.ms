fn replaceAll2 str outStr inStr =
	(
	local ss1 = stringstream ""
	local ss2 = stringstream ""
	
	with printAllElements on ss1 = (str as string) as stringstream
	
	seek ss1 0
	while not eof ss1 do
		(
		local c = readChar ss1
		if c == outStr then c = inStr
		format "%" c to:ss2
		)
	return ss2 as string
	)



fn replaceAll str outStr inStr =
	(
	local str = #(str,"")

	while findstring str[1] outStr != undefined do
		(
	-- get variables
		local s1 = 1
		local s2 = (findstring str[1] outStr) + (-1)
		local s3 = (findstring str[1] outStr) + outStr.count

	-- build str[2]
		str[2]+= substring str[1] s1 s2
		str[2]+= inStr
		
	-- reduce str[1]
		str[1]= substring str[1] s3 str[1].count
		)
	str[2]+=str[1]
	return str[2]
	)
(
t1 = timestamp()
replaceAll str " " "-"
t2 = timestamp()
format "time: %\n" (t2-t1)

t1 = timestamp()
replaceAll2 str " " "-"
t2 = timestamp()
format "time: %\n" (t2-t1)
)