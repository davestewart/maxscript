rollout ro1 "Options" width:472 height:128
(
	GroupBox grpDirs "I/O Directories" pos:[8,8] width:456 height:64
		button btnDirImp "Import Dir" pos:[16,24] width:56 height:16
		label lblDirImp "...path..." pos:[80,24] width:376 height:16
		button btnDirExp "Export Dir" pos:[16,48] width:56 height:16
		label lblDirExp "...path..." pos:[80,48] width:376 height:16

	GroupBox grpOptions "Options" pos:[8,80] width:208 height:40
		checkbox chkStripCam "Strip Cameras" pos:[16,96] width:96 height:16
		checkbox chkStripLgt "Strip Lights" pos:[112,96] width:96 height:16

	GroupBox grpProgress "Progress" pos:[224,80] width:240 height:40
		button btnStart "Start" pos:[232,96] width:40 height:16
		progressBar pb1 "ProgressBar" pos:[280,96] width:176 height:16


	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------


--files = getFiles "E:\\2 - Current Jobs\\doods - phase 2\\4 - environment development\\www.3dcafe.com\\models\\~unzipped\\*.3ds" 
--for f in files do (
--	importFile f #noPrompt
--	)


--path3ds = (getSavePath caption:"Pick 3ds directory")

--getFilenameFile files[20]

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

)

if 3dsConverter != undefined then closerolloutfloater 3dsConverter
	3dsConverter = newRolloutFloater "3ds Converter" 188 500 
addRollout ro1 3dsConverter


