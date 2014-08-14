fn pad num len char:"0"=
(
	local str = num as string;
	while str.count < len do
	(
		str = char + str;
	)
	str
)

print (pad 10 3)