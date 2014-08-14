fn uppercase inStr =
	(
	local i, upper, lower
	upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	lower = "abcdefghijklmnopqrstuvwxyz"
	i = findstring lower inStr
	if i != undefined then return substring upper i 1
	)

for obj in objects do
	(
	str1 = uppercase (substring obj.name 1 1)
	str2 = substring obj.name 2 obj.name.count
	if str1 != undefined then obj.name = str1 + str2
	)
