str1 = "Hello there are you having a nice day?"

while ((i=findstring str1 "e") != undefined) do
	(
	str1 = replace str1 i 2 "obj"
	print str1
	)
/*	
replace <string> <from_integer> <length_integer> <new_string> 
Returns a new string where the substring in string starting at index from_integer, and of length length_integer, is replaced with the new_string. new_string can be any length. The sum of from_integer and length_integer must be less than the length of string. An example usage is: 
s="1234567890" 
s1=replace s 5 3 "inserted string" -- returns "1234inserted string890" 

if ((i=findstring str1 "e") != undefined) then print i
*/