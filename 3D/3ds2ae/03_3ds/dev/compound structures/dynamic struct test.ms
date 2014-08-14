----------------------------------------------------------------------------------
-- make struct example
----------------------------------------------------------------------------------

	-- function
		function makeStruct str=
			(
			arr=filterstring str " "
			str = ""
			for i = 2 to arr.count do str+=arr[i]+", "
			str=substring str 1 (str.count-2)
			local s=execute ("struct "+arr[1]+"("+str+")")
			print s
			)
		
		arr=#(
		"residents cream amnesia since the opening the last three",
		"weeks have proved be",
		"a shrewd move creams part",
		"shapeshifters simon marlin")
	
	-- make the structs
		for a in arr do makeStruct a
	
	-- manipulate the sub stucts
		residents=residents()
		
		residents.cream=1
		
		a=residents()
		
		residents.cream=shapeshifters()
		
		residents.cream.simon=12


----------------------------------------------------------------------------------
-- create and delete sub-struct example
----------------------------------------------------------------------------------
	-- initialize
		test=undefined
		(
		local test
		struct test(var1,var2,var3)
		result=test()
		)
	-- results
		format "test is: %\n" test
		format "result is: %\n" result
	
	-- copy and maipulate
		copyOfResult = copy result
		copyOfResult.var1=10


----------------------------------------------------------------------------------
-- functions within structs example
----------------------------------------------------------------------------------
	-- create
		struct prop(name,value,fn getString=return name + " : " + value as string)
		
	-- initialize
		val=prop "height" value:12
		val.getString()


----------------------------------------------------------------------------------
-- convert array to struct example
----------------------------------------------------------------------------------
	-- array
		effect=#(
			"Blur",
			#("Amount",100),
			#("Fade",0)
			)

	-- 