rollout roSetup "Setup" width:408 height:64
(
-----------------------------------------------------------------
-- main interface

	label lblComp "Comp:" pos:[16,10] width:32 height:16
		dropdownList ddComps "" pos:[48,8] width:326 height:21 items:#("Click button to update comp list...")
		button btnRefresh "<" pos:[376,10] width:16 height:16 tooltip:"Update comp list..."

	label lblRange "Frames:" pos:[9,35] width:40 height:16
		dropdownList ddRange "" pos:[48,32] width:96 height:21 items:#("Current range", "Current frame", "Custom...")
		spinner spnRangeFrom "From: " pos:[176,35] width:52 height:16 range:[0,9999,0] type:#integer scale:1
		spinner spnRangeTo "To: " pos:[248,35] width:52 height:16 range:[0,9999,100] type:#integer scale:1
		spinner spnRangeBy "By:" pos:[328,35] width:40 height:16 range:[1,100,10] type:#integer scale:1


-----------------------------------------------------------------
-- includes

	include "core/jsx.ms"
	include "core/utility.ms"

-------------------------------------------------------------------------------------------------------------------
-- COMPS
-------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------
	-- declarations
	
		local compArr=#()
		local ddItems=#()
	
	-----------------------------------------------------------------
	-- functions
	
		function getCompInfo=
		(
			return compArr[ddComps.selection]
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
				local activeComp=undefined
				for i = 1 to compArr.count do
				(
					local data=compArr[i]
					local str=stringstream ""
					local fps= round (data[6] as float)
					local dur=(data[5] as float*fps) as integer
					--format "% :     % x % x %     ( %f @ %fps )" data[1] data[2] data[3] data[4] dur (round fps) to:str
					format "% :     % x % x %f" data[1] data[2] data[3] dur to:str
					append ddItems (str as string)
					if data[data.count]=="true" then activeComp = i
					/*
					*/
				)
				ddComps.items=ddItems
				if activeComp != undefined then ddComps.selection=activeComp

				--getTextExtent "Comp Cube"
				-- a space is 3 px
			)
	
	-----------------------------------------------------------------
	-- handlers
	
	
		on ddComps selected sel do
		(
			if compArr.count>0 then max2ae.compName=compArr[sel][1]
		)
	
		on btnRefresh pressed do getCompList()
		
-------------------------------------------------------------------------------------------------------------------
-- TIME
-------------------------------------------------------------------------------------------------------------------

	
		fn updateRangeUI sel =
		(
			spnRangeFrom.enabled=spnRangeTo.enabled=(sel==3)
			spnRangeBy.enabled=(sel!=2)
			if sel==1 then
			(
				spnRangeFrom.value=animationRange.start
				spnRangeTo.value=animationRange.end
			)
		)

		fn getRangeInfo=
		(
			local val
			updateRangeUI ddRange.selection
			case ddRange.selection of
			(
				1:	val=#(animationRange.start,animationRange.end,spnRangeBy.value)
				2:	val=#(currentTime,currentTime,1)
				3:	val=#(spnRangeTo.value,spnRangeTo.value,spnRangeBy.value)
			)
			return val
		)

	-- From and To

		on spnRangeFrom changed val do
		(
			if val >= spnRangeTo.value then spnRangeTo.value=val
		)
	
		on spnRangeTo changed val do
		(
			if val <= spnRangeFrom.value then spnRangeFrom.value=val
		)

		on ddRange selected sel do updateRangeUI sel

-------------------------------------------------------------------------------------------------------------------
-- ROLLOUTS
-------------------------------------------------------------------------------------------------------------------

		fn setTitle state=
		(
			if compArr.count>0 then
			(
				local comp=compArr[ddComps.selection][1]
				local range
				case ddRange.selection of
				(
					1:	range=spnRangeFrom.value as string +" - "+spnRangeTo.value as string+" / "+spnRangeBy.value as string
					2:	range="current frame"
					3:	range=spnRangeFrom.value as string +" - "+spnRangeTo.value as string+" / "+spnRangeBy.value as string
				)
	
				if state then roSetup.title="Setup : "+comp+ "  ("+range+")"
				else roSetup.title="Setup"
			)
		)

		on roSetup open do updateRangeUI 1
		
		
		
)

if max2ae==undefined then createDialog roSetup