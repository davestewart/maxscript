/*
-------------------------------------------------------------------------------------------------------------------------------
-- Overview
-------------------------------------------------------------------------------------------------------------------------------

Name:			List Struct
Description:		As max doesn't have associative arrays, holdling name/value pairs is somewhat difficult

				This struct provides a method to store name / value pairs, and in addition provides
				functions such as searching, sorting and printing

-------------------------------------------------------------------------------------------------------------------------------
-- Script Info
-------------------------------------------------------------------------------------------------------------------------------

Version:			0.5
Max version:		Any

Author:			Dave Stewart
Website:			www.davestewart.co.uk / www.keyframesandcode.com

History:			04 Jun 2008	- created
				05 Jun 2008	- added sort functionality
							- reordered functions
				06 Jun 2008	- updated help
							
-------------------------------------------------------------------------------------------------------------------------------
-- Properties and Methods
-------------------------------------------------------------------------------------------------------------------------------

				Properties

					* <array> items <name> <value> - the key/value pairs.
						  * Names can be a #name, "string", or even an index
						  * Values can be any MaxWrapper value (i.e. anything)

				Setters

					* <ListItem> addItem <name> <value>	- adds an item to the List, and if it already exists
					* <ListItem> setItem <name> <value>	- synonym for the above

				Getters

					* <value> getValue <name>			- returns the value of the named item
					* <index> getIndex <name>			- returns the index of the named item
					* <name> getName <value>			- returns the name of the first item that matches the supplied value
					* <ListItem> getItem <name>			- returns the List item corresponding to the supplied name (typically, you wouldn't use this, as you know the name component already, it's just included for completeness)

					* <array> getItems()				- returns all items as an array of ListItem structs
					* <array> getNames()				- returns all names as an array
					* <array> getValues()				- returns all values as an array

				Clear or delete

					* <array> clear()					- clears the lit of all items, and returns the empty ListItems array
					* <boolean> deleteItem <name>		- deletes the named item from the list
					* <boolean> deleteIndex <index>		- deletes the item at the index

				Utilities

					* <array> sort field:<name> order:<name> func:<function> - sorts the list in a variety of ways
					* <string> print()				- prints the List items to the Listener
					
				Save and load
					
					* <boolean> save <filename> section:<string>
					* <boolean> load <filename> section:<string>

*/

-------------------------------------------------------------------------------------------------------------------------------
-- structs
-------------------------------------------------------------------------------------------------------------------------------

	struct ListItem
	(
		name = "", 
		value = ""
	)

	struct List
	(
		------------------------------------------------------------------------------
		-- properties
		
			items = #(),
			
		------------------------------------------------------------------------------
		-- pre-declaration
		
			fn getIndex name =
				(
				local index = 0
				for i = 1 to items.count do
				(
					if items[i].name == name do
					(
						index = i
						exit
					)
				)
				index
				),
			
		------------------------------------------------------------------------------
		-- setters
		
			function addItem name value =
			(
				local index = getIndex name
				if index == 0 do index = items.count + 1
				items[index] = ListItem name value
			),
			
			function setItem name value =
			(
				addItem name value
			),
			
		------------------------------------------------------------------------------
		-- getters (single)
		
			function getItem name =
			(
				local index = getIndex name
				if index != 0 do items[index]
			),
			function getValue name =
			(
				local index = getIndex name
				if index != 0 do items[index].value
			),
			function getName value =
			(
				for i = 1 to items.count do if items[i].value == value do return items[i].name
			),
			
		------------------------------------------------------------------------------
		-- getters (multiple)
		
			fn getItems = (items),
			fn getNames = (for i = 1 to items.count collect items[i].name),
			fn getValues = (for i = 1 to items.count collect items[i].value),
			
		------------------------------------------------------------------------------
		-- clear or delete items
		
			fn clear =
			(
				items = #(); 
				items
			),
			
			function deleteItem name =
			(
				local index = getIndex name
				if index != 0 then
				(
					deleteitem items index
					true
				)
				else
				(
					false
				)
			),

			function deleteIndex index =
			(
				if index < items.count do
				(
					deleteItem items index
					true
				)
			),
			
		------------------------------------------------------------------------------
		-- utilities
		
			fn sort order:#asc field:#name func: =
			(
				-- comparison functions
					fn compareAsc v1 v2 = v1 > v2
					fn compareDesc v1 v2 = v1 < v2
					
				-- choose comparison function
					if func == unsupplied then func = if order == #desc then compareDesc else compareAsc
					else field = #value
					
				-- sort by names or values
					field = if field == #value then #value else #name
					
				-- do the sort
					while true do
					(
						local changed = false
						for i = 1 to (items.count - 1) do
						(
							if func (getProperty items[i] field) (getProperty items[i+1] field) do
							(
								swap items[i] items[i+1]
								changed = true
							)
						)
						if not changed then exit
					)
					
				-- return
					if field == #value then getValues() else getNames()
			),
			
			fn print =
			(
				for i = 1 to items.count do format "%:	%\n" items[i].name items[i].value
			)
		
	)


-------------------------------------------------------------------------------------------------------------------------------
-- Code examples
-------------------------------------------------------------------------------------------------------------------------------
/*
	-- to run these examples, select the code and press SHIFT + ENTER
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- basic example
	
		-- create initial List
		
			names	= #("five", "four", "three", "two", "one")
			values	= #(5,4,3,2,1)

			lst		= List()
			for i = 1 to 5 do lst.addItem names[i] values[i]

		-- grab some items
		
			lst.getItem("three")
			lst.getIndex("two")

		-- view the entire list
		
			lst.print()

	-------------------------------------------------------------------------------------------------------------------------------
	-- sorting the basic example
	
		-- sort the list by names, then print it

			lst.sort()
			lst.print()

		-- sort the list by value, then print it
		
			lst.sort field:#value
			lst.print()

		-- sort the list by value, in reverse, then print it
		
			lst.sort field:#value order:#desc
			lst.print()


	-------------------------------------------------------------------------------------------------------------------------------
	-- advanced sorting (sorting on the list values' child arrays)
	
		-- create a List object with all values being 2-element arrays

			lst = List()
			for i = 20 to 1 by - (random 1 5) do lst.setItem i #((random 100 1000), 1)
			lst.print()
			
		-- create a comparison function to sort the List by the value's first element
			
			fn compareFirstIndex arr1 arr2 = arr1[1] > arr2[1]
			
		-- perform the sort (note: when supplying a function, it is the values that are automatically sorted)
			
			lst.sort func:compareFirstIndex
			lst.print()

	-------------------------------------------------------------------------------------------------------------------------------
	-- more advanced sorting (sorting on the list value's objects' distance from the origin)
	
		-- create a List object with all values being new spheres

			lst = List()
			pos = [1000, 0, 0]
			for i = 1 to 10 do lst.setItem ("Object " + i as string) (sphere pos:(random [0, 0, 0] pos))
			lst.print()
			
		-- create a function to visually show the order of the spheres, 
		-- so we can tell if the sorting has worked or not
			
			fn showSpheres =
				(
				local spheres = lst.getValues()
				for s in spheres do (select s; sleep 0.2; redrawviews())
				)

			showSpheres()
			
		-- create a comparison function to sort the List by the value's first element
			
			fn comparePosition obj1 obj2 = distance obj1.pos [0,0,0] > distance obj2.pos [0,0,0]
			
		-- perform the sort (note: when supplying a function, it is the values that are automatically sorted)
			
			lst.sort func:comparePosition
			lst.print()
			showSpheres()
			

*/
