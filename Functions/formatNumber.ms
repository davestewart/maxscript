fn formatNumber num mask:"###,###,###,###.##" =
(
	local nDec	= num - (num as int)
	local nNum	= num as int
	local sDec	= ""
	local sNum	= ""
	local j		= 1
	for i = mask.count to 1 by -1 do 
	(
		if mask[i] == "#" do 
		(
			sNum = sNum + 
			j += 1
		)
	)
	return sNum + "." + sDec
)
	
formatNumber 12300.34457


with printAllElements on do print 12300.34457


format "%\n" mod 11010.254


num = 12300.34457

mod 11010.254 1


filterstring "###,###,###,###.##" "."