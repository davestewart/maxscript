	fn tabulate str tabStop=
		(
		-- make sure tabstop is on a multiple of 4
			local tabLength	= 4.0
			tabStop = ((tabStop/tabLength as integer)+1) * tabLength

		-- get variables		
			local strLength	= str.count
			local n			= (tabStop - strLength) / tabLength
			local strTab	= ""

		-- if the string length is a multiple, you don't need another tab
			if mod strLength (tabLength as float) == 0.0 then n-=1

		-- add the tabs	
			for i = 0 to n-1 do str+="	"
			str+="	"
		
		-- end
			return str
		)

	str = ""
	(
	for i = 1 to 60 do if mod i 4 == 1 then format ".	"
	format "\n"
	)
	for i = 1 to 20 do
		(
		str += (mod i 10 as integer) as string
		format "%% %\n" (tabulate str 15) i (mod i 4.0)
		)

/*
30.0/4
30/4

38/4.0


32/4.0
30/4.0
28/4.0


for i = 0 to 20 do
	(
	format "% - %\n" i (mod i 4.0)
	)
*/


