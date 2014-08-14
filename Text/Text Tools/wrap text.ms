str = "We weren’t even supposed to have one, it was just a puppy the Murdoch girl found under a Gristede’s truck one day and she was afraid the truck would run over it when the driver had finished making his delivery, so she stuck it in her knapsack and brought it to the school with her. So we had this puppy. As soon as I saw the puppy I thought, Oh Christ, I bet it will live for about two weeks and then... And that’s what it did. It wasn’t supposed to be in the classroom at all, there’s some kind of regulation about it, but you can’t tell them they can’t have a puppy when the puppy is already there, right in front of them, running around on the floor and yap yap yapping. They named it Edgar – that is, they named it after me."


function wrapText str maxLength hyphenate:false=
	(
	
	if NOT hyphenate then
		(
		local para = ""
		local line = ""
		local word = ""
		local str = str as stringstream
		while peekToken str != undefined do
			(
			word = readToken str
			line += word + " "
			if line.count > maxLength then (
				para += line + "\r"
				line = ""
				)
			)
		return para
		)
	else(
		para = ""
		
		local arr = filterstring str "\r"
		local str = ""
		for a in arr do str += a + " "
		
		for i = 1 to str.count by maxLength do
			(
			para += substring str i maxLength
			if substring para (para.count) 1 != " " then para += "-"
			para += "\r"
			)
		return para
		)
	)
	
	

($.baseobject.text = wrapText $.baseobject.text 30)