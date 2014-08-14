clearListener()

struct List(
	-- items
		item1="One",
		item2="Two",
		item3="Three",

	-- funky code	
		thisList=list,
		fn addItem name value=
		(
			local names=getPropNames thisList
			local values=for prop in names collect (thisList getProperty prop)
			
			append names name
			append values value
			thisList=makeStruct names values
		)
)

list=List()


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