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
		tmpStruct=undefined
		
	-- values
		for i = 1 to names.count do setProperty s (names[i] as string) values[i]

	-- return
		return s
)

struct List
(
	thisList
	/*,
	fn addItem name value=
	(
		-- initialize
			local names=#()
			local values=#()

		-- collect the existing props
			local names=getPropNames thisList
			local values=for prop in names collect (getProperty thisList prop)

		-- add the new props	
			append names name
			append values value

		-- create a new items struct and replace
			--local tmpStruct=makeStruct names values
			--execute(thisList+"=tmpStruct")
			print tmpStruct
	)
		*/
)
	

newList=List()

newList.thisList=""--newList


newList.thisList





