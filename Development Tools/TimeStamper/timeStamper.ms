-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Time Stamper
-- A collection of methods to make light work of timing tasks, benchmarking, etc
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		0.5
-- max version:	all
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
--
-- history:		10th May 2008 - Created
--
-------------------------------------------------------------------------------------------------------------------------------

	struct timeStamper
		(
		
		-----------------------------------------------------------------------------------------------------------------------
		-- local variables
		-----------------------------------------------------------------------------------------------------------------------

			task			= "",
			t1				= 0,
			t2				= 0,
			duration		= 0,
			durations		= #(),
			
		-----------------------------------------------------------------------------------------------------------------------
		-- utility functions
		-----------------------------------------------------------------------------------------------------------------------
		
			fn getDuration	= (duration),
			fn getAverage	= (local total = 0; for t in durations do total += t; total /= (durations.count as float)),
			
			fn getString average:false =
				(
				local str			= stringstream ""
				
				if average == true then
					(
					local strAverage = getAverage() as string
					if task == "" then
						format "Average processing time was % seconds, based on % timed sessions." strAverage durations.count to:str
					else
						format "Average processing time for '%' was % seconds, based on % timed sessions." task strAverage durations.count to:str
					)
				else
					(
					if task == "" then
						format "Processing took % seconds." duration to:str
					else
						format "Processing '%' took % seconds." task duration to:str
					)
				str as string
				),
			
		-----------------------------------------------------------------------------------------------------------------------
		-- struct methods
		-----------------------------------------------------------------------------------------------------------------------
		
			fn start		= (t2 = undefined; t1 = timeStamp()),
			fn end			= (t2 = timestamp();duration = (t2 - t1) / 1000.0; append durations duration; duration),
			fn reset		= (t1 = 0; t2 = 0; duration = 0; durations = #()),
			
			fn print average:false =
				(
				if t2 == undefined do end()
				format (getString average:average + "\n")
				),
				
			fn prompt average:false=
				(
				if t2 == undefined do end();
				local str = getString average:average
				displayTempPrompt str 3000
				),
				
			fn alert average:false=
				(
				if t2 == undefined do end();
				local str = getString average:average
				messagebox str
				)

		)
		
-------------------------------------------------------------------------------------------------------------------------------
-- Code examples
-------------------------------------------------------------------------------------------------------------------------------
/*

	ts = timeStamper "Testing"
	
	ts.start()
	-- your code here
	ts.end()
	
	ts.alert()
	ts.prompt average:true
	ts.print average:true

*/