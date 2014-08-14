/*
appFolder="E:\\03_Scripting\\3ds2ae\\03_3ds\\rollout code\\"
appAE="C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"
iniFile=		appFolder+"\\core\\settings.ini"
*/


try(destroyDialog roOptions);catch()

rollout roOptions "Options" width:528 height:328
(

include "core/utility.ms"

-----------------------------------------------------------------
-- main interface

	GroupBox grpAfterEffects "After Effects" pos:[8,8] width:512 height:40
	label lblAfter "After Effects exe" pos:[16,24] width:80 height:16
	edittext edt_appAE "" pos:[96,24] width:400 height:16 enabled:false
	button btnOpen "<" pos:[496,24] width:16 height:16

	GroupBox grp3dsmax "3dsmax" pos:[8,56] width:512 height:40
	label lblData "Data storage:" pos:[16,72] width:72 height:16
	radiobuttons rdoDataStore "" pos:[96,72] width:210 height:16 labels:#("user properties", "track view") columns:2
	checkbox chkSync "Sync comp / scene before export" pos:[312,72] width:200 height:16 checked:true

	GroupBox grpAnimation "Animation" pos:[8,104] width:512 height:96
	GroupBox grpOrigin "Use origin object" pos:[16,120] width:160 height:72
	dropdownList ddlOriginType "" pos:[24,136] width:56 height:21 items:#("Light", "Null", "None")
	spinner spnScaleOrigin "Scale %: " pos:[120,139] width:48 height:16 range:[0,100,100] type:#integer scale:1
	
	GroupBox grpHierarchy "Hierarchy" pos:[184,120] width:160 height:72
	radiobuttons rdoExport "Export as" pos:[192,136] width:149 height:46 labels:#("Parent space (hierarchies)", "World space (un-parented)") columns:1
	
	GroupBox grpKeyframes "Keyframing" pos:[352,120] width:160 height:72
	radiobuttons rdoKeyframes "Keyframes" pos:[360,136] width:123 height:46 labels:#("Bezier keyframes", "A key on every frame") columns:1

	GroupBox grpRendering "File structure" pos:[8,208] width:248 height:88
	dropdownList ddlFileNaming "" pos:[16,232] width:232 height:21 items:#("scene | camera | version | frame", "camera | frame")

	GroupBox grpHousekeeping "Housekeeping" pos:[264,208] width:256 height:88
	checkbox chkNameLayers "Name AE layers from G-Buffer name" pos:[272,224] width:200 height:16 checked:true
	checkbox chkNameEffects "Name AE effects from G-Buffer name / ID" pos:[272,240] width:200 height:16 checked:true
	checkbox chkCommentProj "Comment AE project items with max file + cam." pos:[272,256] width:240 height:16 checked:true
	checkbox chkCommentFiles "Comment files on disk with max file + camera" pos:[272,272] width:246 height:16 checked:true

	button btnDone "Done" pos:[8,304] width:496 height:16
	button btnHelp "?" pos:[504,304] width:16 height:16

-----------------------------------------------------------------
-- functions

	fn loadOptions=
		(
		if iniFile == undefined then messagebox "The variable 'iniFile' is not defined"
		else try(
			local fStr=getIniSetting iniFile "After Effects" "appAE"
			if doesFileExist fStr then edt_appAE.text=fStr
			else edt_appAE.text="<AfterFX application not found>"
			)
		catch()
		)

	fn saveOptions=
		(
		format "Saving options...\n"
		-- After Effects
			--setIniSetting iniFile "After Effects" "app" edt_appAE.text


		destroyDialog roOptions

		)


-----------------------------------------------------------------
-- handlers
	

	on roOptions open do loadOptions()

	on roOptions close do saveOptions()
	
	on btnOpen pressed do
		(
		appAE=getAppAE()
		if appAE != undefined then
			(
			edt_appAE.text=appAE
			setIniSetting iniFile "After Effects" "appAE" appAE
			)
		else 
			(
			edt_appAE.text="<AfterFX application not found>"
			setIniSetting iniFile "After Effects" "appAE" "undefined"
			--messagebox "AfterFX application not found."
			)
		)

	on btnDone pressed do destroydialog roOptions


)

--if max2ae==undefined then 
--createdialog roOptions-- modal:true



