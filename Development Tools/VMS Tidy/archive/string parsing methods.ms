a= "token! -- /* comment!\n */ ( ( \"nested bracket\" pair ) ) " as stringstream 
(while peekToken a != undefined do print (readToken a);ok) 


a= "This si ( \"s as\"djh  ) jsdh jshdfk hsdf  " as stringstream 
str=""
(while peekToken a != undefined do str+=(readToken a + "\t");ok) 
str

/*
The following string parsing methods were first introduced in gmax 1.0 and are available in MAXScript since 3ds max 5. 
<Boolean>isSpace <String> 
Returns true if the first character of the given string is whitespace (space, tab, or newline), false if not. 
Example 
isSpace " MAXScript" --first character is space -> true 
true 
isSpace "MAXScript" --first character is not whitespace -> false 
false 
isSpace "\nMAXScript" --first character is new line -> true 
true 
<String>trimLeft <String> [String trimChars] 
Trims all leading characters specified in trimChars from the given string and returns it. If trimChars is not specified, basic whitespace characters (space, tab, and newlines) are trimmed. 
Example 
trimleft " \nMAXScript" --space and new line trimmed 
"MAXScript" 
<String>trimRight <String> [String trimChars] 
Trims all trailing characters specified in trimChars from the given string and returns it. If trimChars is not specified, basic whitespace characters (space, tab, and newlines) are trimmed. 
Example 
trimright "MAXScript \n " --spaces and new line trimmed 
"MAXScript" 
trimright "$Teapot0911" "1234567890" --remove trailing numbers 
"$Teapot" 
*/