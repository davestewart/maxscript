clearListener()


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
	
	mystruct=makeStruct #(#var1,#var2,#var3) #("One","Two","Three")
	mystruct.var3
	


struct List (
		names=#(),
		values=#(),
		
		fn setVal str val=
			(
			)
		)
		
test

setProperty books "names" "helo"


books.names

classof books



fn jump str=print str


mystruct.var3=jump

mystruct.var3 #gaga