---------------------------------------------------------------------------------
/*
This is a first attempt to re-create the functionality of associative arrays in maxscript.

OK, here's what I've come up with. It seems to work for now, but I'm sure it's breakable. 
Essentially it dynamically rebuilds exsiting structs and adds new values during the process.

It creates a List "class" that holds sub-items. Create a new List instance by assigning it to a variable like so:

newList=List()


Then proceed to add items using the addItem() function like so:

newList.addItem #height 10


New Lists can be put into existing lists like so:

newList.addItem #books (List())
newList.items.books.addItem #disney "The illusion of life"


Objects can then be referenced like so: 

 - [listVariable].items.[objectName]
 - [listVariable].items.[listName].items.[listName].items.[objectName]


*/
---------------------------------------------------------------------------------
-- structure definition
---------------------------------------------------------------------------------

	clearListener()

	struct List(
		items,
		function makeStruct names values=
			(
			-- names
				local str=""
				for i = 1 to names.count do str+=(names[i] as string)+","
				str=substring str 1 (str.count-1)
				
			-- create temp struct
				global tmpStruct
				execute ("struct tmpStruct("+str+")")
				local s=tmpStruct()
				tmpStruct=undefined
				
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



---------------------------------------------------------------------------------
-- example
---------------------------------------------------------------------------------

	-- create the main list
		newList=List()
		newList.addItem "object" objects

	-- add items to list
		newList.addItem #height 10
		newList.addItem #width 20
		newList.addItem #depth 30
	
	-- add a sub list
		-- create it
			books=List()
			books.addItem #disney "The illusion of life"
			books.addItem #dickens "a christmas carol"
	
		-- add it
			newList.addItem #books (List())
			newList.items.books.addItem #disney "The illusion of life"

	
	-- inspect the list
		newList.items.width
		newList.items.books.items.disney
		getPropNames newList.items.books


---------------------------------------------------------------------------------
-- structure layout
---------------------------------------------------------------------------------
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
