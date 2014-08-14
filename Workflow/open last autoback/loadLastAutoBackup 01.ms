(
----------------------------------------------------------------------------------------------
-- struct: date
----------------------------------------------------------------------------------------------

	-- PURPOSE:
		-- create a new date object from a string.
	
	-- USAGE:
		-- useful for comparing dates, such as file modified date,
		-- by seconds elapsed since the year 2000 (default)
	
	-- CONSTRUCTOR:
		-- d = date.dateFromString "mm/dd/yy hh:mm:ss PM" [year:yyyy]
		-- d = dateFromString (getFileCreateDate (getFiles "$max/3dsmax.ini")[1])
	
	-- RETURNS:
		-- an instance of a date struct

	-- PROPERTIES:
		-- y, m, d:		year, month, day
		-- hh, m, ss:	hours, minutes, seconds	
		-- t:			time; how many seconds have elapsed since the default year (2000)

----------------------------------------------------------------------------------------------

	struct date
	(
		-- variables
			y, m, d, hh, mm, ss, t,
			
		-- methods
			fn fromString str year:2000 =
			(
				-- error checking
					if classof str != String do
					(
						format "-- Runtime error: 'date.fromString' requires a string of the format \"mm/dd/yy hh:mm:ss PM\"\n"
						return undefined
					)
	
				-- vars
					local a, d

					a		= filterstring str " "
					if a.count != 3 do
					(
						format "-- Runtime error: 'date.fromString' requires a string of the format \"mm/dd/yy hh:mm:ss PM\"\n"
						return undefined
					)
					
					a[1]	= filterstring a[1] "/"
					a[2]	= filterstring a[2] ":"
	
				-- create instance and define properties
					d		= date()
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
					
				-- assign
					d.t = t
			)
	)

----------------------------------------------------------------------------------------------
-- functions
----------------------------------------------------------------------------------------------

	function getFilesByDate filenameString type:#modified order:#ascending debug:false =
	(
		-- error checking
			if classof date != StructDef do
			(
				format "-- Runtime error: function 'getFilesByDate' requires the 3rd-party struct 'date'\n"
				return #()
			)
				
			if type != #modified AND type != #created then
			(
				format "-- Runtime error: function 'getFilesByDate' parameter 'type' should be #modified or #created\n"
				return #()
			)
	
		-- get files
			local str, d
			local arr	= #()
			local files	= getFiles filenameString
			
			for f in files do
			(
				str		= if type == #created then getFileCreateDate f else getFileModDate f 
				d		= date.fromString str
				append arr #(d.t, str, f)
			)
	
		-- sort files		
			fn orderFn v1 v2 order:#ascending =
			(
				-- vars
					local val
					if order == #descending then val = v2[1] - v1[1]
					else val = v1[1] - v2[1]
				-- calcs
					case of
					(
						(val < 0): -1
						(val > 0): 1
						default: 0
					)
			)
			
			qsort arr orderFn order:order
			
		-- debug
			if debug == true do print arr
			
		-- return
			for i = 1 to arr.count do arr[i] = arr[i][3]
			return arr
	)

----------------------------------------------------------------------------------------------
-- testing
----------------------------------------------------------------------------------------------

	-- get the date of a file

		file	= (getFiles "$max\\3dsmax.ini")[1]
		strDate	= getFileModDate file
		d		= date.fromString strDate
		
	-- open last autobackup

		function loadLastAutoBackup =
		(
			local arr = getFilesByDate "$max\\Autoback\\Autobak*" order:#descending -- debug:true
			if arr.count > 0 then loadmaxfile arr[1]
		)

		loadLastAutoBackup()
)

