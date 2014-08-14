clearListener()

fn addItem2Struct  name value=
(
	local names=getPropNames theList
	local values=for prop in names collect (getProperty theList prop)
	
	append names name
	append values value

	local tmpStruct=makeStruct names values
	format ">%\n" tmpStruct
	theList=tmpStruct
	items=tmpStruct
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
	items,
	fn addItem name value=
	(
		-- initialize
			local names=#()
			local values=#()

		-- collect the existing props
			if items != undefined then
			(
				local names=getPropNames items
				local values=for prop in names collect (getProperty items prop)
			)
		-- add the new props	
			append names name
			append values value

		-- create a new items struct and replace
			local tmpStruct=makeStruct names values
			items=tmpStruct
			
			format "> %\n" items
		),
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

)


newList=List()
newList.addItem "height" 10
newList.addItem "width" 20
newList.addItem "depth" 30

books=List()
books.addItem "disney" "The illusion of life"

newList.addItem "books" books



newList.items.width

list.addItem newList "height" 10
list.addItem newList "width" 20


newList.items.books.items.disney

getPropNames newList.items.books


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
