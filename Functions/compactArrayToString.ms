fn compactArrayToString arr =
	(
	local ss1 = stringstream ""
	local ss2 = stringstream ""
	
	with printAllElements on ss1 = (arr as string) as stringstream
	
	seek ss1 1
	while not eof ss1 do
		(
		local c = readChar ss1
		if c == "#" then format " %" c to:ss2
		else if c != " " then format "%" c to:ss2
		)
	return ss2 as string
	)
	
	
arr = for i = 1 to 30 collect i
compactArrayToString "#(1, 2, 3, 4), #(5 ,6, 7, 8)"
