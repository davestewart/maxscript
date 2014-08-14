-- functions

	fn pad str strPad:"0" len:2 =
	(
		str = str as string
		while str.count < len do str = (strPad as string) + str
		str
	)
		

	fn getDimension obj axis =
	(
		local dim = obj.max - obj.min
		dim[axis]
	)

	fn createText str font: size:50 name: steps: =
	(
		local t = text text:str
		if size != unsupplied do t.size = size
		if font != unsupplied do t.font = font
		if name == unsupplied do t.name = (uniquename "Text")
		if steps != unsupplied do t.steps = steps
		t
	)
		
-- variables
	size	= 30
	kerning	= 0
	steps	= 2
	font	= "Garamond Italic"
	str 	= "What's up, Pussycat?"

-- create text objects
	arr = for i = 1 to str.count collect substring str i 1
		
	for i = 1 to arr.count do 
	(
		local s = arr[i]
		if s != " " do
		(
		-- set basetext string
			local baseText = createText (substring str 1 i) size:size font:font steps:steps name:"base text"
			baseText.pivot.x = - (getDimension baseText 1) / 2
			baseText.pos.x = 0
			
		-- create new text
			t = createText s size:size font:font steps:steps 
			t.pos.x = (getDimension baseText 1) - ((getDimension t 1) / 2)
			t.name = "Text" + (pad i) + " - " + s--" \"" +str+ "\""
			
		-- cleanup
			delete baseText
		)
	)


