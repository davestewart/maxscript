fn doIt obj =
	(
--	local tempStr = testStr as stringstream
	format "The object is :" to:testStr
	format "%\n" obj.name to:testStr


	close testStr
	print(testStr as string)
	)



-- variables
global testStr = "" as stringstream
doIt $
testStr=undefined