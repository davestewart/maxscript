rollout ro1 "Options" width:392 height:184
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------

	local str = "The MAXScript language is specifically
designed to complement 3ds max. It has
many special features and constructs such
as coordinate system contexts, object
primitives and materials that mirror high-
level concepts in the 3ds max user-
interface."
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	edittext edt1 "1: " width:384 height:144 text:str
	edittext edt2 "2: " width:384 height:144
	button btn1 "Execute" width:80 height:16



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	on btn1 pressed do
		(

		local txt1 = stringstream edt1.text
		local txt2 = ""

		while not (eof txt1) do
			(
			txt2 += "
		" + (readLine txt1)
			)

		close txt1

		edt2.text = txt2
		)





)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 425 440
addRollout ro1 myFloater