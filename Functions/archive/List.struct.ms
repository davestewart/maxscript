-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Name:		List Struct
-- Description:	As max doesn't have associative arrays, holdling name/value pairs is somewhat difficult
--				This structs provides a place to store name / value pairs, and in addition provides
--				functions such as searching, sorting and printing
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		0.5
-- max version:	Any
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
/*
-- history:		04 Jun 2008 - created
				05 Jun 2008 - added sort functionality
							- reordered functions
*/
-------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
-- struct
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
		
			names = #(),
			values = #(),
			
		------------------------------------------------------------------------------
		-- setters
		
			function addItem name value =
		(
				local index = finditem names name
				if index == 0 do index = names.count + 1
				names[index] = name
				values[index] = value
				true
			),
			
			function setItem name value =
		(
				addItem name value
				true
			),
			
		------------------------------------------------------------------------------
		-- getters
		
			function getItem name =
		(
				local index = finditem names name
				if index != 0 do values[index]
			),
			fn getIndex name = (finditem names name),
			fn getItems = (for i = 1 to names.count collect #(names[i], values[i])),
			fn getNames = (names),
			fn getValues = (values),
			
		------------------------------------------------------------------------------
		-- clear or delete items
		
			fn clear =
		(
				names = #(); 
				values = #()
				true
			),
			
			function deleteItem name =
		(
				local index = finditem names name
				if index != 0 then
			(
					deleteitem names index
					deleteitem values index
					true
			)
				else
			(
					false
			)
			),

			function deleteIndex index =
		(
				if index < names.count do
			(
					deleteitem names index
					deleteitem values index
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
					arrs = if field == #value then #(values, names) else #(names, values)
					
				-- do the sort
					while true do
				(
						local changed = false
						for i = 1 to (arrs[1].count - 1) do
					(
							if func arrs[1][i] arrs[1][i+1] do
						(
								for j = 1 to arrs.count do swap arrs[j][i] arrs[j][i+1]
								changed = true
						)
					)
						if not changed then exit
				)
					
				-- return
					arrs
			),
			
			fn print =
		(
				for i = 1 to names.count do format "%:	%\n" names[i] values[i]
		)
		
)


-------------------------------------------------------------------------------------------------------------------------------
-- Code examples
-------------------------------------------------------------------------------------------------------------------------------
/*
	
	-------------------------------------------------------------------------------------------------------------------------------
	-- basics
	
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
	-- sorting
	
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
			
			fn selectSpheres =
			(
				ss = lst.getValues()
				for s in ss do (select s; sleep 0.2; redrawviews())
			)

			selectSpheres()
			
		-- create a comparison function to sort the List by the value's first element
			
			fn comparePosition obj1 obj2 = distance obj1.pos [0,0,0] > distance obj2.pos [0,0,0]
			
		-- perform the sort (note: when supplying a function, it is the values that are automatically sorted)
			
			lst.sort func:comparePosition
			lst.print()
			selectSpheres()
			

*/


