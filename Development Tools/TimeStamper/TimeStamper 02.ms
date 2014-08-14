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

			task				= "",
			t1					= 0,
			t2					= 0,
			duration			= 0,
			durations			= #(),
			
		-----------------------------------------------------------------------------------------------------------------------
		-- utility functions
		-----------------------------------------------------------------------------------------------------------------------
		
			fn getLast			= (duration),
			fn getTotal			= (local total = 0; for t in durations do total += t; total),
			fn getAverage		= (local total = getTotal(); total /= (durations.count as float)),
			
			fn getDifference ts average:false = 
			(
				local t1 = if average == true then getAverage() else duration
				local t2 = if average == true then ts.getAverage() else ts.duration
				local n1 = task
				local n2 = ts.task
				
				if amin t1 t2 == t1 then
				(
					local difference = t2 / t1
					local testOrder = #(n1, n2)
				)
				else
				(
					local difference = t1 / t2
					local testOrder = #(n2, n1)
				)
					
				#(difference, testOrder[1], testOrder[2])
				),
			
			fn getString average:false difference: =
			(
				local str = stringstream ""
				
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
					
				if difference != unsupplied do
				(
					local arr = getDifference difference average:average
					format "\n'%' was % times quicker than '%'\n" arr[2] arr[1] arr[3] to:str
				)
				str as string
				),
			
		-----------------------------------------------------------------------------------------------------------------------
		-- struct methods
		-----------------------------------------------------------------------------------------------------------------------
		
			fn start		= (t2 = undefined; t1 = timeStamp()),
			fn end			= (t2 = timestamp();duration = (t2 - t1) / 1000.0; append durations duration; duration),
			fn reset		= (t1 = 0; t2 = 0; duration = 0; durations = #()),
			
			fn print average:false difference: =
			(
				if t2 == undefined do end()
				local str = getString average:average difference:difference
				format (str + "\n")
				),
				
			fn prompt average:false difference: =
			(
				if t2 == undefined do end();
				local str = getString average:average difference:difference
				displayTempPrompt str 3000
				),
				
			fn alert average:false difference: =
			(
				if t2 == undefined do end();
				local str = getString average:average difference:difference
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
	
	t1 = timeStamper("Test 1")
	t1.start()
	t1.end()
	
	t2 = timeStamper("Test 2")
	t2.start()
	t2.end()
	
	
	t1.print()
	t2.print difference:t1


*/