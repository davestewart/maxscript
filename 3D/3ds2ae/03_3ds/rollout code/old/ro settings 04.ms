(

include "ro options 01.ms"
local roSettings

rollout roWarning "Warning" width:344 height:208
	(
	label lbl1 "It appears that some settings between the 3dsmax scene and After Effects comp do not match, which could cause timing and / or movement anomalies." pos:[24,16] width:296 height:40
	label lbl2 "Before continuing, would you like to:" pos:[88,72] width:176 height:16
	radiobuttons rdoSel "" pos:[88,96] width:119 height:32 labels:#("Update After Effects", "Update 3dsmax", "Do nothing (not recommended)") columns:1
	button btnOK "OK" pos:[80,168] width:88 height:24 enabled:true
	button btnCancel "Cancel" pos:[176,168] width:88 height:24 enabled:true

	on btnOK pressed do
		(
		roSettings.checkBeforeExport sel:rdoSel.state
		destroydialog roWarning
		)
	
	on btnCancel pressed do
		(
		destroydialog roWarning
		)
		
	)

--createdialog roWarning lockHeight:true lockWidth:true --modal:true


rollout roSettings "Settings" width:408 height:64
	(

	-----------------------------------------------------------------
	-- interface
	
		label lblComp "Comp:" pos:[16,10] width:32 height:16
			dropdownList ddComps "" pos:[48,8] width:326 height:21 items:#("Click button to update comp list...")
			button btnRefresh "<" pos:[376,10] width:16 height:16 tooltip:"Update comp list..."
	
		label lblRange "Frames:" pos:[9,35] width:40 height:16
			dropdownList ddRange "" pos:[48,32] width:96 height:21 items:#("Current range", "Current frame", "Custom...")
			spinner spnRangeFrom "From: " pos:[176,35] width:52 height:16 range:[0,9999,0] type:#integer scale:1
			spinner spnRangeTo "To: " pos:[248,35] width:52 height:16 range:[0,9999,100] type:#integer scale:1
			spinner spnRangeBy "By:" pos:[328,35] width:40 height:16 range:[1,100,10] type:#integer scale:1

			button btnOptions "" pos:[376,35] width:16 height:16 tooltip:"Options..."  images:#("ui/options.bmp", "ui/optionsMask.bmp", 1, 1, 1, 1, 1) toolTip:"Copy settings"

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
	
		function getCompList=
			(
			-- run the AE script
				runJSX "getCompList.jsx"
				sleep 0.1
	
			-- pick up the file
				local compListFile=(SETTINGS.appFolder+"jsx\\comps.dat")
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
			if compArr.count>0 then SETTINGS.compName=compArr[sel][1]
			)
	
		on btnRefresh pressed do getCompList()
		
		on btnOptions pressed do createdialog roOptions
		
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
-- SETTINGS
-------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------
	-- declarations
	
		local appFolder="E:\\03_Scripting\\3ds2ae\\03_3ds\\rollout code\\"
		local appAE=getIniSetting "core/settings.ini" "After Effects" "app"
		local appFirstRun=getIniSetting "core/settings.ini" "3dsmax" "FirstRun"

		local maxSceneInfo=#()
		local aeCompInfo=#()
		
		local compName, compWidth, compHeight, compPixelAspect, compFps, compDuration

		local animRange=#(0,100,25)
		local animSpace=#parent--#world


	-----------------------------------------------------------------
	-- functions

		fn checkAppAE=
			(
			if findstring appAE "AfterFX.exe" != undefined OR doesFileExist appAE != true then
				(
				--messageBox "The location of AfterFX.exe is not known. Please select it in the next dialogue box."
				local str=getopenfilename caption:"Select After Effects application file (AfterFX.exe)..." types:"Application (*.exe)|AfterFX.exe"
				if str!=undefined then setIniSetting (appFolder+"core/settings.ini") "After Effects" "app" str
				)
			)

		fn checkBeforeExport sel:undefined=
			(
			-- check for ae
			-- update range settings
			-- check comp has been chosen
			-- check comp properties
			-- return true
			
			-- check for After Effects application
			--messagebox (sel as string)
			if sel==undefined then
				(
				maxSceneInfo=#(maxfilename,renderWidth, renderHeight, renderPixelAspect, frameRate, (animationrange.end-animationrange.start))
				aeCompInfo=#(compName, compWidth, compHeight, compPixelAspect, compFps, compDuration)
				for i = 2 to aeCompInfo.count do
					(
					format "% : % | %\n" (i as string) aeCompInfo[i] maxSceneInfo[i]
					if aeCompInfo[i] != maxSceneInfo[i] then (createdialog roWarning lockHeight:true lockWidth:true /*modal:true*/;exit)
					)
				)
			else(
				-- update time
					updateRangeUI ddRange.selection
					animRange=case ddRange.selection of
						(
						1:	#(animationRange.start,animationRange.end,spnRangeBy.value)
						2:	#(currentTime,currentTime,1)
						3:	#(spnRangeTo.value,spnRangeTo.value,spnRangeBy.value)
						)

				-- update comp
					--compArr[ddComps.selection]

				if sel==1 then
					(
					format "Updating After Effects...\n"
					)
				else if sel==2 then
					(
					format "Updating 3dsmax...\n"
					)
				messagebox "Exporting!"
				return true
				)
			)



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

		on roSettings open do
			(
			updateRangeUI 1
			updateBeforeExport()
			checkAppAE()
			)

	)

if max2ae==undefined then createDialog roSettings
)