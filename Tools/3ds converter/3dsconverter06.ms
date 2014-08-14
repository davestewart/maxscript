rollout ro1 "Options" width:472 height:152
(

	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	local pathImp="", pathExp="", files, countFiles
	local oldVPortBGColor = getVPortBGColor()
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	GroupBox grpDirs "Directories" pos:[8,8] width:456 height:64
	button btnDirImp "Import Dir" pos:[16,24] width:56 height:16
	button btnDirExp "Export Dir" pos:[16,48] width:56 height:16
	edittext edtPathImp "" pos:[72,24] width:384 height:16 --text:pathImp
	edittext edtPathExp "" pos:[72,48] width:384 height:16 --text:pathExp

	--button btnPrintDirImp "<" pos:[0,24] width:16 height:16
	--button btnPrintDirExp "<" pos:[0,48] width:16 height:16
	--on btnPrintDirImp pressed do print ("pathImp= " + pathImp as String)
	--on btnPrintDirExp pressed do print ("pathExp= " + pathExp as String)

	GroupBox grpOptions "Options" pos:[8,80] width:232 height:56
	checkbox chkStripCam "Strip Cameras" pos:[16,96] width:96 height:16 checked:true
	checkbox chkStripLgt "Strip Lights" pos:[16,112] width:96 height:16 checked:true
	checkbox chkReGround "Place on xy plane" pos:[114,96] width:118 height:16 checked:true
	colorPicker cpVPColor "" pos:[110,113] width:17 height:14 color:(color 128 166 214) title:"Choose a Viewport Background color"
	label lblVPColor "Viewport BG Color" pos:[132,113] width:92 height:16
	button btnVPColorReset "X" pos:[-113,113] width:14 height:14 tooltip:"Reset Viewport Background color"



	GroupBox grpProgress "Progress" pos:[248,80] width:216 height:56
	button btnStart "Start" pos:[424,96] width:32 height:32
	progressBar pb1 "ProgressBar" pos:[256,96] width:160 height:16 value:0
	label lblStatus "Ready..." pos:[256,117] width:160 height:16


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
fn convertFiles =
(

	if (pathImp == "" OR pathExp== "") then
	(
		messageBox "You need to select Import / Export directories to convert files" title:"File I/O Error" beep:true
	)
	else
	(

	-- Query
		if queryBox "3dsmax will generate thumbnails by taking a \nscreen-grab of the viewport you last clicked in.\n\nIt would be wise to make sure it is set-up \nto get a good view of any objects imported, \nas well as ensuring no dialogue boxes or \nfloaters are obscuring it before continuing.\n\nDo you want to start the conversion process?" title:"Thumbnail generation advice" then
		(
			-- initial setup
			 	i=0
				for f in files do (
				-- variables
					i+=1
					fileName = getFilenameFile f as String
			
				-- progress
					grpProgress.text = "File: " + i as String + " of " + files.count as String + " (" + filename + ")"
					pb1.value = ((i as Float/files.count) * 100) as Integer
					print f
			
				-- setup & import
					lblStatus.text = "Deleting objects..."
					delete objects
					lblStatus.text = "Importing... "
					importFile f #noPrompt
			
			
				-- Updating
					lblStatus.text = "Updating..."
					if chkStripCam.checked then delete cameras
					if chkStripLgt.checked then	delete lights
					if chkReGround.checked then(
						select objects
						selection.pos.z = - selection.min.z
					)
			
				-- get ready for save
					lblStatus.text = "Viewport setup... "
					clearSelection()
					max tool zoomextents all
			
				-- save
					lblStatus.text = "Saving... "
					saveNodes objects (pathExp + "\\" + fileName + ".max")
			)			
				grpProgress.text = "Progress"
				lblStatus.text = "Ready..."
				pb1.value = 0
		)


	)
)

	fn countFiles =
	(
		try(
			files = getFiles ((getFilenamePath pathImp) as String + "*.3ds")
			grpProgress.text = "Progress: (0 of " + files.count as String + ")"
		)
		catch ()
	)

	fn getPathImp =
	(
		fileImp = getOpenFileName caption:"Select first *.3ds file to import..." types:"3D Studio Mesh (*.3ds)|*.3ds" ()
		pathImp =  getFilenamePath fileImp

		edtPathImp.text = pathImp as String
		countFiles()

		if pathExp == "" then
		(
			pathExp = pathImp
			edtPathExp.text = pathExp as String
		)


	)	
	
	fn getPathExp =
	(
		pathExp = getSavePath()
		format "pathExp= %" pathExp
		edtPathExp.text = pathExp as String
	)


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------


	on ro1 open do
	(
		edtPathImp.text = pathImp as String
		edtPathExp.text = pathExp as String
		countFiles()
		
	)

	on ro1 close do setVPortBGColor(oldVPortBGColor)

	on btnDirImp pressed do	getPathImp()

	on btnDirExp pressed do	getPathExp()

	on edtPathImp changed text do
	(
		pathImp = text
		countFiles()
	)
	on edtPathExp changed text do pathExp = text

	on cpVPColor changed col do --pos:[110,113]
	(
		setVPortBGColor col
		cpVPColor.pos=[-110,113]
		btnVPColorReset.pos=[114,113]
	)

	on btnVPColorReset pressed do --pos:[113,113]
	(
		cpVPColor.pos=[114,113]
		btnVPColorReset.pos=[-113,113]
		setVPortBGColor oldVPortBGColor
		cpVPColor.color=(color 128 166 214)
	)

	on btnStart pressed do convertFiles()
)

if Floater3dsConverter != undefined then closerolloutfloater Floater3dsConverter
	Floater3dsConverter = newRolloutFloater "3ds Converter" 500 201
addRollout ro1 Floater3dsConverter
