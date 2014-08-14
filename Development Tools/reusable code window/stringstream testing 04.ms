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
	button btn1 "Execute, and randomly insert tabs and returns" height:16

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btn1 pressed do
		(

		-- set up tab and return characters
			-- tab character (even though it might look like a space, it is definately a "tab")
				local t = "	"

			-- return character
			local r = "
"

		-- set up text box strings
			local txt1 = stringstream edt1.text
			local txt2 = ""
		

		-- work through the string
			while not (eof txt1) do
				(
				char = (readChar txt1)
				if char != "\n" then
					(
					txt2 += char								-- insert next character from stringstream
					if (random 1 10) == 1 then txt2 += r		-- also, randomly insert return character
					if (random 1 10) == 1 then txt2 += t		-- also, randomly insert tab character
					)
				else
					(
					txt2 += r									-- correctly insert return character
					)
				)
			close txt1

		-- assign the string
			edt2.text = txt2
		)
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 425 440
addRollout ro1 myFloater