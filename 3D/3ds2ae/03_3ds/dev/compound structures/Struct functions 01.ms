struct List(items)
		function makeStruct names values=
		(
			-- names
				local str=""
				for i = 1 to names.count do str+=(names[i] as string)+","
				str=substring str 1 (str.count-1)
				
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

		fn addItem items name value=
		(
			-- initialize
				local names=#()
				local values=#()
	
			-- collect the existing props
				if items != undefined then
				(
					local names=getPropNames items
					local values=for prop in names collect (getProperty items prop)
				)
			-- add the new props	
				append names name
				append values value
	
			-- create a new items struct and replace
				local tmpStruct=makeStruct names values
				tmpStruct
				--items=tmpStruct
		)

			
(
struct test(a,b,c)
--local 
s=test()
s=addItem s #dave 45
s=addItem s #pete 60
s=addItem s #objects $s*


print s
select s.objects

s= addItem s #books (List())

s.books = addItem s.books #dickens "a christmas carol"
s.books = addItem s.books #disney "snow white"

addItem s.books #disney "a christmas carol"


s.books

)