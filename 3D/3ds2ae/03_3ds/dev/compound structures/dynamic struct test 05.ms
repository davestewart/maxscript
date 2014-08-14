clearListener()

struct List(
	items,
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
		),
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
	)

)

-- create the main list
	newList=List()
	newList.addItem "height" 10
	newList.addItem "width" 20
	newList.addItem "depth" 30

-- add a sub list
	-- create it
		books=List()
		books.addItem "disney" "The illusion of life"
		books.addItem "dickens" "a christmas carol"

	-- add it
		newList.addItem "books" books

-- inspect the list
	newList.items.width
	newList.items.books.items.disney
	getPropNames newList.items.books

/*
-- structure
	List
		items <data>
			itemName <data>
			itemName <data>
		addItem <fn>
		makeStruct <fn>
		
	List
		itemName <data>
		itemName <data>
		addItem <fn>
*/
