a = "Have a nice day won't you!\nThank You, I will!\nLove Dave"
b = stringstream a

clearListener()

b
seek b 0
readLine b
readValue b
skipToNextLine b



/*
readValue <stringstream> 
readExpr <stringstream> 
readLine <stringstream> 
readChar <stringstream> 
readChars <stringstream> <number> 
readDelimitedString <stringstream> <string> 
skipToString <stringstream> <string> 
skipToNextLine <stringstream> 
execute <stringstream> 
filePos <stringstream> 
seek <stringstream> <pos> 
eof <stringstream> 
close <stringstream> 
flush <stringstream> 
*/

while not eof b
print (readLine b)

win = newScript()
format a to:win