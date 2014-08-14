rollout roSetup "Setup" width:408 height:64
(
-----------------------------------------------------------------
-- includes

	include "core/jsx.ms"
	include "core/utility.ms"

-----------------------------------------------------------------
-- main interface

	label lblComp "Comp:" pos:[16,10] width:32 height:16
		dropdownList ddComps "" pos:[48,8] width:326 height:21 items:#("Click button to update comp list...")
		button btnRefresh "<" pos:[376,10] width:16 height:16

	label lblRange "Range:" pos:[8,35] width:40 height:16
		dropdownList ddRange "" pos:[48,32] width:96 height:21 items:#("Current range", "Current frame", "Custom...")
		spinner spnRangeFrom "From: " pos:[176,35] width:52 height:16 range:[0,9999,0] type:#integer scale:1
		spinner spnRangeTo "To: " pos:[248,35] width:52 height:16 range:[0,9999,100] type:#integer scale:1
		spinner spnRangeBy "By:" pos:[328,35] width:40 height:16 range:[1,100,10] type:#integer scale:1


-------------------------------------------------------------------------------------------------------------------
-- COMPS
-------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------
	-- declarations
	
		local compArr=#()
		local ddItems=#()
	
	-----------------------------------------------------------------
	-- functions
	
		function updateCompInfo sel=
		(
			--print roSettings
			--max2aefloater.controls[1].rollouts[2].title = "Current Settings: [ Comp 1, frames 10 - 55 ]"
			--roSettings.title = "cunt"--"Current Settings: [ "+compArr[sel][1]+", frames 10 - 55 ]"
		)
	
		function getCompList=
		(
			-- run the AE script
				runJSX "getCompList.jsx"
				sleep 0.1
	
			-- pick up the file
				local compListFile=(max2ae.appFolder+"jsx\\comps.dat")
				f=openFile compListFile mode:"r"
				if f != undefined then
				(
					compArr=#()
					while not eof f do
					(
						txt=readline f
						if txt.count>1 then append compArr (filterstring txt "\t")
					)
					close f
					--deleteFile compListFile
			)
	
			-- populate the list
				ddItems=#()
				--getTextExtent "Comp Cube"
				-- a space is 3 px
				for arr in compArr do
				(
					local str=stringstream ""
					local fps= round (arr[6] as float)
					local dur=(arr[5] as float*fps) as integer
					--format "% :     % x % x %     ( %f @ %fps )" arr[1] arr[2] arr[3] arr[4] dur (round fps) to:str
					format "% :     % x % x %f" arr[1] arr[2] arr[3] dur to:str
					append ddItems (str as string)
				)
				ddComps.items=ddItems
				
			-- update the UI
				updateCompInfo 1
				
			)
	
	-----------------------------------------------------------------
	-- handlers
	
	
		on ddComps selected sel do
		(
			if compArr.count>0 then updateCompInfo sel
		)
	
		on btnRefresh pressed do getCompList()
		
-------------------------------------------------------------------------------------------------------------------
-- TIME
-------------------------------------------------------------------------------------------------------------------

	
		fn updateTimePrefs=
		(
			local val
			case rt of
			(
				1:	val=#(spnRangeTo.value,spnRangeTo.value,spnRangeBy.value)
				2:	val=#(spnRangeTo.value,spnRangeTo.value,spnRangeBy.value)
				3:	val=#(spnRangeTo.value,spnRangeTo.value,spnRangeBy.value)
			)

			--animRange=
		)

		fn updateTimeUI sel =
		(
			spnRangeFrom.enabled=spnRangeTo.enabled=(sel==3)
			spnRangeBy.enabled=(sel!=2)
		)

	-- From and To

		on spnRangeFrom changed val do
		(
			if val >= spnRangeTo.value then spnRangeTo.value=val
			updateTimePrefs()
		)
	
		on spnRangeTo changed val do
		(
			if val <= spnRangeFrom.value then spnRangeFrom.value=val
			updateTimePrefs()
		)

		on ddRange selected sel do updateTimeUI sel

)

if max2ae==undefined then createDialog roSetup