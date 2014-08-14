struct date
	(
	-- PURPOSE:
	-- create a new date object from a string.
	
	-- USAGE:
	-- useful for comparing dates, such as file modified date, by seconds elapsed since the year 2000 (default)
	
	-- CONSTRUCTOR:
	-- d = date.dateFromString "mm/dd/yy hh:mm:ss PM" [year:yyyy]
	-- d = dateFromString (getFileCreateDate (getFiles "$max/3dsmax.ini")[1])
	
	-- RETURNS:
	-- an instance of a date struct

	-- PROPERTIES:
	-- y, m, d:		year, month, day
	-- hh, m, ss:	hours, minutes, seconds	
	-- t:			how many seconds have elapsed since the year 2000

	
	-- variables
		y, m, d, hh, mm, ss, t,
		
	-- methods
		fn dateFromString str year:2000 =
			(
			-- error checking
				if classof str != String do return false

			-- vars
				local a	= filterstring str " "
				a[1]	= filterstring a[1] "/"
				a[2]	= filterstring a[2] ":"

			-- create instance and define properties
				local d = date()
				d.d		= a[1][2] as integer
				d.m		= a[1][1] as integer
				d.y		= a[1][3] as integer
				d.hh	= a[2][1] as integer
				d.mm	= a[2][2] as integer
				d.ss	= a[2][3] as integer
				
				if a[3] == "PM" do d.hh += 12
				
				date.secondsElapsed &d year:year
			-- return			
				return d
			),
		fn secondsElapsed &d year:2000 =
			(
			-- vars
				local t				= if year > 1990 then 0 else 0.0
				local secondsInDay	= 60 * 60 * 24
				local daysInMonth	= #(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

			-- y, m, d		
				for y = year to (d.y - 1) do
					(
					if mod y 4 == 0 then t += 366 * secondsInDay 
					else t += 365 * secondsInDay 
					)
				
				for m = 1 to (d.m - 1) do
					(
					t += daysInMonth[m] * secondsInDay
					)
				if (mod d.y 4 == 0) AND d.m >= 3 do t += secondsInDay -- leap year
					
				t += (d.d - 1)	* secondsInDay
			
			-- hh, mm, ss
				t += d.hh		* 60 * 60
				t += d.mm		* 60
				t += d.ss
				
			-- return
				d.t = t
			)
	)

-- tests



(
clearlistener()

local files	= getFiles "$max\\Autoback\\Autobak*"
local files	= getFiles "$max\\help\\*"
local arr	= #()

for f in files do
	(
	local str	= getFileModDate f
	local d		= date.dateFromString str
	append arr #(d.t, str, f)
	)

print arr
	
fn order v1 v2 order:#ascending =
	(
	-- vars
		local val
		if order == #ascending then val = v1[1] - v2[1]
		else val = v2[1] - v1[1]
	-- calcs
		case of
			(
			(val < 0): -1
			(val > 0): 1
			default: 0
			)
	)

qsort arr order order:#ascending

print ""
print arr
)



/*
for d in dates do
	(
	d = date.dateFromString d
	format "%\n" d.t
	)
)

2106744624.0 * 2
print arr




for p in positions do print p
*/



/*
date.dateFromString "1/1/2000 12:01:00 AM"
12 * 60 * 60
classof "" == String





print files
print dates

--qsort


*/