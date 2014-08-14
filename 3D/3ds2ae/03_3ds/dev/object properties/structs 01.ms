-- declare the struct	
	struct data(str1,str2)
	--#Struct:data(
	--  str2:<data>,
	--  str1:<data>)

--instantiate a new instance of the struct to a variable
	myData=data "hello" "world"
	--data str1:"hello" str2:"world"
	
-- test the struct's properties
	myData.str1
	--"hello"

-- define a new global variable
	str1
	--undefined

-- set the variable to be the same as the strauct's property of the same name
	str1=myData.str1
	--"hello"
	
-- change the struct's data
	myData.str1="goodbye"
	--"goodbye"
	
--check the global variable - it's different
	str1
	--"hello"
	
	myData.str1="goodbye"
	
	myData2 = data "hello" myFn

myData2.str2 1 3





myData2 1 3


myFn= (fn sum a b=(return a+b))

myFn