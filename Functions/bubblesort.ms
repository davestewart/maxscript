fn bubblesort arrs func:#asc =
(
	-- set up return type
		local single = true
	
	-- put a single array in a an 2D array, so it can be sorted
	-- in the same manner as if a 2D array had been passed in
		if classof arrs[1] != Array then arrs = #(arrs)
		else single = false
		
	-- check that all elements are arrays
		for a in arrs do if classof a != Array do throw "bubblesort: first argument must be an array, or an array of arrays"
	
	-- comparison functions
		fn compareAsc v1 v2 = v1 > v2
		fn compareDesc v1 v2 = v1 < v2
		
	-- select comparison function
		if superclassof func != Name then
		(
			func = case func of
			(
				#desc: compareDesc
				#asc: compareAsc
				default: compareAsc
			)
		)
		else if superclassof func as string != "Function" then
		(
			throw "bubblesort: argument 'func' must be a sort type (#asc, #desc) or a custom comparison function"
		)

	-- do the sort
		while true do
		(
			local changed = false
			for i = 1 to (arrs[1].count - 1) do
			(
				if func arrs[1][i] arrs[1][i+1] do
				(
					for j = 1 to arrs.count do
					(
						swap arrs[j][i] arrs[j][i+1]
					)
				changed = true
				)
			)
			if not changed then exit
		)
		
	-- return
		if single then arrs[1] else arrs
)


fn sortArrays arrs order:#asc =
(
	-- comparison functions
		fn compareAsc v1 v2 = v1 > v2
		fn compareDesc v1 v2 = v1 < v2
		
	-- select comparison function
		func = if order == #desc then compareDesc else compareAsc
	
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
)
-- arrays
	arr1 = #(5,4,3,2,1)
	arr2 = #("five", "four", "three", "two", "one")
	arr3 = #("FIVE", "FOUR", "THREE", "TWO", "ONE")

-- sort all
	bubblesort #(arr1, arr2, arr3) func:#asc

-- results
	arr1
	arr2
	arr3
