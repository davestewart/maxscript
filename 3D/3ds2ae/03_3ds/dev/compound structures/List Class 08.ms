function makeStruct theStruct names values=
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

fn addItem structName name value=
(
	-- initialize
		local names=#()
		local values=#()

	-- collect the existing props
		local theStruct=execute(structName)
		local names=getPropNames theStruct
		local values=for prop in names collect (getProperty theStruct prop)

	-- add the new props	
		append names name
		append values value

	-- create a new items struct and replace
		local tmpStruct=makeStruct theStruct names values
		execute (structName+"= tmpStruct")
)


struct v1 (a,b,c)
struct v2 (x,y,z)

n1=v1()
n2=v2()

addItem "n2" "name" "dave"

n2


(
local theStruct =n1
local names=getPropNames theStruct
local values=for prop in names collect (getProperty theStruct prop)
)

getProperty n1 "a"

getPropNames n1

struct test (a,b)
