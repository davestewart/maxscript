struct date
(
	-- PURPOSE:
	-- create a new date object from a string.
	
	-- USAGE:
	-- useful for comparing dates by seconds elapsed since the year 2000 (default)
	
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
				
				date.secondsElapsed &d year:2000
			-- return			
				return d
			),
		fn secondsElapsed &d year:2000 =
		(
			-- vars
				local t				= 0
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
str = "01/01/2000 00:10:20
01/02/2000 01:10:20
02/28/2000 02:10:20
02/29/2000 03:10:20
03/01/2000 04:10:20
01/01/2001 05:10:20
01/02/2001 06:10:20
02/28/2001 07:10:20
03/01/2001 08:10:20
01/01/2006 09:10:20
01/02/2006 10:10:20
02/28/2006 11:10:20
03/01/2006 12:10:20"

dates = filterstring str "\n"

for d in dates do
(
	d = date.dateFromString d
	format "%\n" d.t
)
)



fn orderAscending v1 v2 =
(
	local d = (length v1)-(length v2)
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)


qsort positions orderAscending

for p in positions do print p




/*
date.dateFromString "1/1/2000 12:01:00 AM"
12 * 60 * 60
classof "" == String



files = getFiles "$max\\Autoback\\Autobak*"
dates = #()

for f in files do
(
	local str	= getFileCreateDate f
	local d		= date.dateFromString str
	--format "%\n" d
	format "%\n" str
)

print files
print dates

--qsort


*/