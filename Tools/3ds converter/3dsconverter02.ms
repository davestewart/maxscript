rollout ro1 "Options" width:472 height:128
(
	GroupBox grpDirs "I/O Directories" pos:[8,8] width:456 height:64
	button btnDirImp "Import Dir" pos:[16,24] width:56 height:16
	button btnDirExp "Export Dir" pos:[16,48] width:56 height:16
	editText edtPathImp "" pos:[72,24] width:384 height:16
	editText edtPathExp "" pos:[72,48] width:384 height:16

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
fn convertFiles =
(
	files = getFiles (pathImp as String + "*.3ds")
)

--for f in files do (
--	importFile f #noPrompt
--)



--getFilenameFile files[20]

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnDirImp pressed do
(
	pathImp = getOpenFileName caption:"Select import directory (you must select a file)" types:"3D Studio Mesh (*.3ds)|*.3ds" ()
	edtPathImp.text = pathImp as String
)
	on btnDirExp pressed do
(
	--pathExp = getSaveFileName caption:"Select output directory" types:"3ds max (*.max)|*.max" ()
	pathExp = getSavePath
	edtPathImp.text = pathExp as String
)
	on btnStart pressed do
		convertFiles()
)

if Floater3dsConverter != undefined then closerolloutfloater Floater3dsConverter
	Floater3dsConverter = newRolloutFloater "3ds Converter" 500 185
addRollout ro1 Floater3dsConverter


