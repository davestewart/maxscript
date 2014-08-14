rollout ro1 "Options" width:472 height:144
(
	GroupBox grpDirs "Directories" pos:[8,8] width:456 height:64
		button btnDirImp "Import Dir" pos:[16,24] width:56 height:16
		button btnDirExp "Export Dir" pos:[16,48] width:56 height:16
		edittext edtPathImp "" pos:[72,24] width:384 height:16
		edittext edtPathExp "" pos:[72,48] width:384 height:16

	GroupBox grpOptions "Options" pos:[8,80] width:112 height:56
		checkbox chkStripCam "Strip Cameras" pos:[16,96] width:96 height:16
		checkbox chkStripLgt "Strip Lights" pos:[16,112] width:96 height:16

	GroupBox grpInfo "Info" pos:[128,80] width:112 height:56
		label lblInfoTotal "Total: 101 Files" pos:[136,96] width:96 height:16

	GroupBox grpProgress "Progress" pos:[248,80] width:216 height:56
		button btnStart "Start" pos:[424,96] width:32 height:32
		progressBar pb1 "ProgressBar" pos:[256,96] width:160 height:16 value:50
		label lblStatus "Opening scene..." pos:[256,117] width:160 height:16


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
	i=0
	files = getFiles ((getFilenamePath pathImp) as String + "*.3ds")

	lblInfoTotal.text = "Total: " + files.count as String + " Files"

	for f in files do (
		i+=1
		grpProgress.text = "File: " + i as String + " of " + files.count as String + " (" + filenameFromPath f as String + ")"
		--lblStatus.text = "Importing " + 

		lblStatus.text = "Importing " + filenameFromPath f as String
		--	importFile f #noPrompt
		print f

		)
		grpProgress.text = "Progress"


	)



--getFilenameFile files[20]


	fn getPathImp =
		(
		pathImp = getOpenFileName caption:"Select first *.3ds file to import..." types:"3D Studio Mesh (*.3ds)|*.3ds" ()
		edtPathImp.text = pathImp as String
		grpProgress.text = "Progress"

		)	
	
	fn getPathExp =
		(
		--pathExp = getSaveFileName caption:"Select output directory for *.max files" types:"3ds max (*.max)|*.max" ()
		pathExp = getSavePath()
		edtPathExp.text = pathExp as String
		)
	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on btnDirImp pressed do
		getPathImp()
	on btnDirExp pressed do
		getPathExp()
	on btnStart pressed do
		convertFiles()
)

if Floater3dsConverter != undefined then closerolloutfloater Floater3dsConverter
	Floater3dsConverter = newRolloutFloater "3ds Converter" 500 201
addRollout ro1 Floater3dsConverter


