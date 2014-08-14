-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Progress Bar Updater
-- A struct to simply and easily update a progress bar by providing just start and end values, and calling "update()"
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		0.5
-- max version:	all
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
--
-- history:		1st May 2008 - created
--
-------------------------------------------------------------------------------------------------------------------------------

	struct progressBarUpdater
	(
		pb			= undefined,
		value		= 0,
		step		= 0,
		
		fn init _pb v1 v2 increment:1 =
		(
			if classof _pb != progressBar do
			(
				throw "The control passed to progressBarUpdater.init() must be a ProgressBar control"
				return false
			)
			if amax v1 v2 == v1 do swap v1 v2
			step		= (100.0 / (v2 - v1)) * increment
			value		= 0
			pb			= _pb
			pb.value	= 0
			),
			
		fn update =
		(
			value		+= step
			pb.value	= value
			),
			
		fn reset =
		(
			value		= 0
			pb.value	= 0
		)
	)
	

-------------------------------------------------------------------------------------------------------------------------------
-- Code example
-------------------------------------------------------------------------------------------------------------------------------

/*
rollout roPbUpdater "ProgressBar Example" width:160 height:70
(
	-- interface
		spinner spn1 "Start" range:[0,100,40] type:#integer fieldwidth:30 across:2
		spinner spn2 "End" range:[0,100,60] type:#integer fieldwidth:30
		button btn1 "Start" width:136
		progressBar pb1 "ProgressBar"

	-- variables
		local pbu
		
	-- functions
		function process v1 v2 =
		(
			-- initialize the progress bar
				pbu.init pb1 spn1.value spn2.value
				
			-- some arbitrary processing code
				local sleepValue = 2 / (distance [v1,0,0] [v2,0,0])
				if amax v1 v2 == v1 do swap v1 v2
				for i = v1 to v2 do
				(
					-- update the progress bar
						pbu.update()
						
					-- code that takes some time
						sleep sleepValue

				)
					
			-- reset the progress bar
				pbu.reset()
		)

	-- handlers	
		on roPbUpdater open do
		(
			pbu = progressBarUpdater()
		)
				
		
		on btn1 pressed do
		(
			process spn1.value spn2.value
		)
)

createdialog roPbUpdater

*/
