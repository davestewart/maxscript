rollout r1 "Text Test" width:264 height:502
(
	fn wrapText str maxW=
		(
		local strArr=#()
		local lastSpace=1
		for i = 1 to str.count do
			(
			if str[i]==" " then lastSpace=i
			local curLine=substring str 1 (lastSpace)
			local w=(getTextExtent curLine).x
			if w>maxW then
				(
				append strArr curLine
				str=substring str (curLine.count+1) str.count
				)
			)
		append strArr str
		str=""
		for s in strArr do str+=s+"\n"
		return str
		)

	label lbl1 "Import properties Anchor point Parent Handle instancing (add UI element: Respect instances) Change rotation properties for parented objects to include inverse transform Rollouts Animation Investigate user prop buffer and parsing the received code Investigate custAttribues + stringtab Have ax store objects property Have createObjectCode function loop \n\n though ax OR selection to do it's thing Have createcode reference the ax when building object / property code Compositing Look at interface Tools" pos:[7,8] width:248 height:490


	on r1 open do
	(
	local str=""
	str= "One problem I've always had with displaying text on the screen in say an edit_texta label etc, is that i always manually have to put in line breaks when i write the etext. This is very inconvinient since if i change the size of the text box I'm forced to edit all these line breaks again!\n\nThere must be a better way. How do you guys do?\nI'm thinking about writing a function that looks in a string an measures the lenght of it, and then put in line breaks automatically in the string where it gets too long. But this doesn't sound that cool to write and may also be processor taxing for longer texts."
	
	str=wrapText str 200
	lbl1.text=str
	)
)

createdialog r1