clearListener()

fn addItem &theList name value=
	(
	local names=getPropNames theList
	local values=for prop in names collect (getProperty theList prop)
	
	append names name
	append values value

	local tmpStruct=makeStruct names values
	format ">%\n" tmpStruct
	theList=tmpStruct
	return tmpStruct
	)


function makeStruct names values=
	(
	-- names
		local str=""
		for i = 1 to names.count do str+=(names[i] as string)+", "
		str=substring str 1 (str.count-2)
		
	-- create temp struct
		global tmpStruct
		execute ("struct tmpStruct("+str+")")
		local s=tmpStruct()
		--tmpStruct=undefined
		
	-- values
		for i = 1 to names.count do setProperty s (names[i] as string) values[i]

	-- return
		return s
	)


struct List(
	-- items
		item1="One",
		item2="Two",
		item3="Three"
	)


newList=List()

newList=addItem newList"height" 10
addItem newList"width" 20

newList

list.addItem newList "height" 10
list.addItem newList "width" 20


getPropNames newList


newList
/*
-- structure
	List
		items
			itemName
			itemName
		add
		
	List
		itemName
		itemName
		add
*/
props=getPropNames newList
for prop in props collect (getProperty newList prop)
