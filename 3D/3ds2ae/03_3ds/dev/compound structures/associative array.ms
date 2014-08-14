clearListener()

struct List (
		names=#(),
		values=#(),
		
		fn setVal str val=
		(
			local i=findItem names (str as string)
			--format ">> %\n" i
			if i>0 then
			(
				names[i]=str
				values[i]=val
			)
			else
			(
				append names str
				append values val
			)
			),

		fn getVal str=
		(
			local i=findItem names str
			if i>0 then return values[i]
		)
	)

-- create a list
	arr=List()
	arr.setVal #name "dave"
	arr.setVal #height 10
	

-- add a sub list
	-- create the list
		books=List()
		books.setVal #shakespeare "much ado about nothing"
		books.setVal #dickens "a christmas carol"
	
	-- add it to the original list
		arr.setVal #books books
		
	-- retrieve the value
		(arr.getVal #books).getVal #shakespeare



/*
		fn delete str=
		(
			local i=findItem names str
			if i>0 then 
			(
				local namesArr=deleteItem names i
				local valuesArr=deleteItem values i
			)
			return #(namesArr,valuesArr)
		)
*/

function