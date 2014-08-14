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
		-- single functions
		-----------------------------------------------------------------------------------------------------------------------
		
			fn getLast			= (duration),
			fn getTotal			= (local total = 0; for t in durations do total += t; total),
			fn getAverage		= (local total = getTotal(); total /= (durations.count as float)),
			
		-----------------------------------------------------------------------------------------------------------------------
		-- compound functions
		-----------------------------------------------------------------------------------------------------------------------
		
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
		-- utility functions
		-----------------------------------------------------------------------------------------------------------------------
		
			fn getReport step:10 to: columns:#(#index, #step, #stepaverage, #steptotal, #slower, #quicker, #total)=
			(
				-- variables
					local allColumns	= #(#index, #step, #steptotal, #stepaverage, #slower, #quicker, #total)

				-- get all column data
					local maxDuration	= amax durations
					local minDuration	= amin durations

					local indices		= #()
					local steps			= #()
					local stepTotals	= #()
					local stepAverages	= #()
					local slowers		= #()
					local quickers		= #()
					local totals		= #()
					
					for col in allColumns do
					(
						case col of
						(
							#index:
							(
								local index = 1
								for i = 1 to durations.count by step do (append indices index; index += 1)
							)
							#step:
							(
								for i = 1 to durations.count by step do append steps i
							)
							#stepTotal:
							--#total:
							(
								local index
								local total = 0
								for i = 1 to durations.count by step do
								(
									local stepTotal = 0
									for j = 1 to step do
									(
										index = (i - 1) + j
										if index <= durations.count then stepTotal += durations[index]
										else exit
									)
									total += stepTotal
									append stepTotals stepTotal
									append totals total
								)	
							)
							#stepAverage:
							(
								for stepTotal in stepTotals do append stepAverages (stepTotal / step as float)
							)
							#slower:
							(
								local stepMax = (amax stepAverages) as float
								for stepAverage in stepaverages do append slowers (stepMax / stepAverage)
							)
							#quicker:
							(
								local stepMin = (amin stepAverages) as float
								for stepAverage in stepAverages do append quickers (stepAverage / stepMin)
							)
						)
					)
				-- get final headers & columns
					local headers		= #()
					local data			= #()
					for col in columns do
					(
						case col of
						(
							#index:			(append headers "Index"; append data indices)
							#step:			(append headers "Step #"; append data steps)
							#steptotal:		(append headers "Step Total"; append data stepTotals)
							#stepaverage:	(append headers "Step Average"; append data stepAverages)
							#slower:		(append headers "x Slower than Quickest"; append data slowers)
							#quicker:		(append headers "x Quicker than Slowest"; append data quickers)
							#total:			(append headers "Cumulative Total"; append data totals)
						)
					)						

				-- generate report

					-- variables
						local str = stringstream ""
						
					-- headers
						for header in headers do format "%	" header to:str
						format "\n" to:str
						
					-- data
						local rows = data[1].count
						local cols = data.count
						
						for y = 1 to rows do
						(
							for x = 1 to cols do
							(
								format "%	" data[x][y] to:str
							)
							format "\n" to:str
						)
					
				-- do something with report
					
					if superclassof to 

					case col of
					(
						#index:			(append headers "Index"; append data indices)
						#step:			(append headers "Step #"; append data steps)
						#steptotal:		(append headers "Step Total"; append data stepTotals)
						#stepaverage:	(append headers "Step Average"; append data stepAverages)
						#slower:		(append headers "x Slower than Quickest"; append data slowers)
						#quicker:		(append headers "x Quicker than Slowest"; append data quickers)
						#total:			(append headers "Cumulative Total"; append data totals)
					)
					format "%" (str as string) to:(newscript())
/*
					*/
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