-- macroscript:	Open Most Recent File
-- version:	1.0
-- date:	October 10th 2006

-- author:	Dave Stewart
-- www:		www.davestewart.co.uk/maxscript

-- purpose:	Opens the most recent file saved, be it an autobackup or a straight file > save
-- install:	Run the file, or drop it in UI/MacroScripts directory, go to Customize UI > Menu > File and drag the entry to the File a menu

Macroscript openMostRecentFile 
	category:"File" 
	internalCategory:"File"
	ButtonText:"Open Most Recent File"
	tooltip:"Open Most Recent File"
	silentErrors:true
	(

	----------------------------------------------------------------------------------------------
	-- struct: date
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
						format "-- Runtime error: date.fromString requires a string of the format \"mm/dd/yy hh:mm:ss PM\"\n"
						return false
						)
	
				-- vars
					local a, d

					a		= filterstring str " "
					if a.count != 3 do
						(
						format "-- Runtime error: date.fromString requires a string of the format \"mm/dd/yy hh:mm:ss PM\"\n"
						return false
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

	function orderFilesByDate files type:#modified order:#descending debug:false =
		(
		-- error checking
			if classof date != StructDef do
				(
				format "-- Runtime error: function 'orderFilesByDate' requires the 3rd-party struct 'date'\n"
				return #()
				)
				
			if classof files != Array do
				(
				format "-- Runtime error: function 'orderFilesByDate' parameter 'files' requires an array of files\n"
				return #()
				)

			if type != #modified AND type != #created then
				(
				format "-- Runtime error: function 'orderFilesByDate' parameter 'type' should be #modified or #created\n"
				return #()
				)
	
		-- get files
			local str, d
			local arr	= #()
			
			for f in files do
				(
				str		= if type == #created then getFileCreateDate f else getFileModDate f 
				d		= date.fromString str
				append arr #(d.t, str, f)
				)
	
		-- sort files		
			fn orderFn v1 v2 order:#descending =
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
			
			qsort arr orderFn order:order
			
		-- debug
			if debug == true do print arr
			
		-- return
			for i = 1 to arr.count do arr[i] = arr[i][3]
			return arr
		)
			
		function openMostRecentFile =
			(
			-- get autoback files and 2 last-saved files
				local files	= getFiles "$max\\Autoback\\Autobak*"
				local f1	= getinisetting "$max/3dsmax.ini" "FileList" "File1"
				local f2	= getinisetting "$max/3dsmax.ini" "FileList" "File2"
				
				if f1 != "" then append files f1
				if f2 != "" then append files f2
				
			-- order files
				local arr = orderFilesByDate files order:#descending -- debug:true
				if arr.count > 0 then loadmaxfile arr[1]
			)
			
			
	----------------------------------------------------------------------------------------------
	-- do it
	----------------------------------------------------------------------------------------------

		on execute do openMostRecentFile()
		
	)
	
