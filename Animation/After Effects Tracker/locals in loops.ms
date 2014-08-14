(
t1 = timestamp()

local str1 = ""
local str2 = ""

for i = 1 to 100 do
	(
	str1	= " "
	str2	= " "
	for j = 1 to 1000 do
		(
		str2 += j as string + " "
		)
	str1 += str2 as string + "\n"
	)
t2 = timestamp()
format "time: %\n"(t2 - t1)
)


(
t1 = timestamp()

local str1 = ""

for i = 1 to 100 do
	(
	str1	= " "
	local str2	= " "
	for j = 1 to 1000 do
		(
		local str3 = j as string + " "
		str2 += str3
		)
	str1 += str2 as string + "\n"
	)
t2 = timestamp()
format "time: %\n"(t2 - t1)
)