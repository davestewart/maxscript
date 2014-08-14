try(destroydialog MzpCreator)catch()
rollout MzpCreator ".mzp Creator" width:432 height:496
(
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██            ██       ██    ██             
	--  ██  ██                     ██    ██             
	--  ██  ██ █████ ████ ██ █████ █████ ██ █████ █████ 
	--  ██  ██    ██ ██   ██    ██ ██ ██ ██ ██ ██ ██    
	--  ██  ██ █████ ██   ██ █████ ██ ██ ██ █████ █████ 
	--   ████  ██ ██ ██   ██ ██ ██ ██ ██ ██ ██       ██ 
	--    ██   █████ ██   ██ █████ █████ ██ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Variables

		-- varaiables
			local zipExePath			= "zip.exe"
			local tempFilePath			= ""

			local TEMP_DIR				= "mzp-creator-temp"
		
			local files					= #()
			local tempFiles				= #()
		
			local SLEEPTIME				= 2
			
		-- predeclarations
			local setDescriptiveText
	
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██        ██               ████                   
	--  ██        ██               ██                     
	--  ██ █████ █████ █████ ████  ██   █████ █████ █████ 
	--  ██ ██ ██  ██   ██ ██ ██   █████    ██ ██    ██ ██ 
	--  ██ ██ ██  ██   █████ ██    ██   █████ ██    █████ 
	--  ██ ██ ██  ██   ██    ██    ██   ██ ██ ██    ██    
	--  ██ ██ ██  ████ █████ ██    ██   █████ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Interface

		GroupBox grpInfo "Properties" pos:[8,8] width:416 height:96
			dotNetControl lvInfo "System.Windows.Forms.ListView" pos:[16,32] width:400 height:62
			
		GroupBox grpSource "Source Files" pos:[8,112] width:416 height:216
			dotNetControl lvFiles "System.Windows.Forms.ListView" pos:[16,136] width:400 height:160
			button btnAddFolder "Add Folder..." pos:[96,304] width:80 height:16
			button btnAddFiles "Add Files..." pos:[16,304] width:80 height:16
			label lblFlattenFolders "Structure:" pos:[186,305] width:48 height:16
			radiobuttons rdoFlattenFolders "" pos:[238,305] width:149 height:16 labels:#("Flatten", "Preserve") columns:2
			
		GroupBox grpScript "Startup Script" pos:[8,336] width:416 height:48
			button btnCreateRun "Create..." pos:[16,360] width:80 height:16
			checkbox chkAddRun "Add \"run\" entries for checked items" pos:[104,361] width:192 height:16
			
		GroupBox grpOutput "Output File" pos:[8,392] width:416 height:88
			edittext edtFilePath "" pos:[13,416] width:384 height:18
			button btnFile "..." pos:[398,416] width:18 height:18
			button btnCreateMzp "Export .mzp" pos:[16,440] width:400 height:32

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██  ██   ██ ██ ██  ██   ██             
	--  ██  ██  ██      ██     ██                  
	--  ██  ██ █████ ██ ██ ██ █████ ██ █████ █████ 
	--  ██  ██  ██   ██ ██ ██  ██   ██ ██ ██ ██    
	--  ██  ██  ██   ██ ██ ██  ██   ██ █████ █████ 
	--  ██  ██  ██   ██ ██ ██  ██   ██ ██       ██ 
	--  ██████  ████ ██ ██ ██  ████ ██ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Utilities

		fn getMultipleFiles =
		(
			local dialog		= dotNetObject "System.Windows.Forms.OpenFileDialog"
			
			dialog.title		= "Select one or more script files to be included in the .mzp package"
			dialog.Filter		= "Script Files (*.ms, *.mcr, *.mse)|*.ms;*.mcr;*.mse|All Files (*.*)|*.*"
			dialog.Multiselect	= true
			dialog.FilterIndex	= 1

			local result		= dialog.showDialog()

			result.ToString()
			if result.Equals result.OK then dialog.fileNames
			else #()
		)
		
		fn shortenFilePath filePath maxLength:60 split:0.5 delimiter:"..." =
		(
			if filePath.count > maxLength then
			(
				maxLength -= delimiter.count
				strStart = substring filePath 1 (maxLength * split)
				strEnd = substring filePath (filePath.count - (maxLength * (1 - split))) filePath.count
				strStart + delimiter + strEnd
			)
			else
			(
				filePath
			)
		)

		fn selectSaveFile =
		(
			local filePath = getSaveFileName types:"Zip-file Script Packages (*.mzp)|*.mzp"

			if filePath != undefined do
			(
				--edtFileName.text = ""
				edtFilePath.text = ""
				--setDescriptiveText filePath
			)
		)
		
		fn selectSavePath =
		(
			local filePath = getsavepath()
			if filePath != undefined do edtFilePath.text = filePath
		)
		
		fn removeQuotes str =
		(
			local arr = filterstring str "\""
			str = ""
			for a in arr do str += a
			str
		)
		
		fn showHelp =
		(
			local url = "mk:@MSITStore:" + (getdir #help) + "\maxscript.chm::/Zip_file_Script_Packages.htm"
			shelllaunch url ""
		)
		
		fn setDescriptiveText filePath =
		(
			if edtFileName.text == "" do
				edtFileName.text				= getFilenameFile filePath + ".mzp"
			
			if edtFilePath.text == "" do
				edtFilePath.text				= getFilenamePath filePath
			
			if edtScriptName.text == "" do
				edtScriptName.text				= getFilenameFile filePath
			
			if edtScriptDescription.text == "" do
				edtScriptDescription.text		= edtScriptName.text + " is a utility to..."
		)
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██████                    ██   ██                   
	--  ██                        ██                        
	--  ██     ██ ██ █████ █████ █████ ██ █████ █████ █████ 
	--  █████  ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██ ██    
	--  ██     ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██ █████ 
	--  ██     ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██    ██ 
	--  ██     █████ ██ ██ █████  ████ ██ █████ ██ ██ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Functions
		
		function resetAll prompt:true=
		(
			local state = if prompt then querybox "Are you sure you want to reset all fields?" else true
			if state do
			(
				files					= #()
				tempFiles				= #()
				ddlFiles.items			= #()
				
				edtScriptName.text			= ""
				edtScriptDescription.text	= ""
				
				edtRun.text				= ""
				edtFileName.text		= ""
				edtFilePath.text		= ""
			)
		)

		function createRunText files=
		(
			-- variables
				local text = ""
			
			-- files
				for f in files do
				(
					text += "run \"" + filenameFromPath f + "\"\n"
				)
				
			-- text
				text
		)
		
		function selectFiles =
		(
			newFiles = getMultipleFiles()
			if newFiles.count > 0 then
			(
				/*
				-- first files
					if files.count == 0 then
					(
						setDescriptiveText newFiles[1]
					)
					
				-- replace files
					if NOT chkAppend.checked then	
					(
						edtRun.text				= ""
						files					= #()
						ddlFiles.items			= #()
					)
					
				-- set up text etc
					edtRun.text					+= createRunText newFiles
					ddlFiles.items				= join ddlFiles.items (for f in newFiles collect shortenFilePath f maxLength:55 split:0.1)
					
				-- update files list
					join files newFiles
				*/
				--lvFiles.add newFiles[i]
				for f in newFiles do
				(
					local row = dotNetUtils.addRow lvFiles #(filenameFromPath f, getFileNamePath f)
				)
			)
		)
		
		function openSelectedFile =
		(
			local index = ddlFiles.selection
			if files.count > 0 AND ddlFiles.selection != undefined do
			(
				local str = "start notepad.exe \"" + files[index] + "\"" 
				doscommand str
			)
		)

		function deleteSelectedFile =
		(
			local index = ddlFiles.selection
			if files.count > 0 AND ddlFiles.selection != undefined do
			(
				local arr = ddlFiles.items
				deleteItem arr index
				deleteItem files index
				ddlFiles.items = arr
			)
		)

		function cleanupFiles =
		(
			tempFiles = getFiles (tempFilePath + "\\*.*")
			for f in tempFiles do
			(
				deleteFile f
			)
		)
		
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██████          ██       
	--  ██              ██       
	--  ██     █████ █████ █████ 
	--  ██     ██ ██ ██ ██ ██ ██ 
	--  ██     ██ ██ ██ ██ █████ 
	--  ██     ██ ██ ██ ██ ██    
	--  ██████ █████ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Code
		
		function createFiles =
		(
			--------------------------------------------------------------------------------------------------------------------------
			-- setup
			
				-- check
					if files.count == 0 do
					(
						messagebox "You haven't selected any files"
						return false
					)
				
					if NOT doesFileExist edtfilePath.text  do
					(
						messagebox "The output directory doesn't exist"
						return false
					)
					
				-- variables
					local fileName		= edtFileName.text
					local filePath		= edtFilePath.text
					local zipParams	= ""
					
			--------------------------------------------------------------------------------------------------------------------------
			-- copy all files
					
				-- make dir
					makeDir tempFilePath
				
				-- copy the zip.exe
					copyFile zipExePath  (tempFilePath + "zip.exe")

				-- copy all the files
					for f in files do
					(
						copyFile f  (tempFilePath + (filenameFromPath f))
						zipParams += " \"" + (filenameFromPath f) +"\" " 
					)
					
				-- create the run file
					if chkRun.checked do
					(
						local runFile = createFile (tempFilePath + "mzp.run")
						
						format "name \"%\"\n" (removeQuotes edtScriptName.text) to:runFile
						format "description \"%\"\n\n" (removeQuotes edtScriptDescription.text) to:runFile
						format edtRun.text to:runFile

						close runFile
						zipParams += " mzp.run "
					)
					

			--------------------------------------------------------------------------------------------------------------------------
			-- do the zipping
					
				-- create the text to zip the file
					local tempZipExe		= tempFilePath + "zip.exe"
					local zipFileName		= (filterstring fileName ".")[1]
					local params			= " \"" +zipFileName + "\"" +zipParams
					
				-- create file
					shelllaunch tempZipExe params
					
				-- delete any existing file
					deleteFile (filePath + zipFileName + ".mzp")
					
				-- rename and move the zip file(after a tiny sleep to make sure all files have been created)
					sleep SLEEPTIME
					renameFile (tempFilePath + zipFileName + ".zip") (filePath + zipFileName + ".mzp")
					
			--------------------------------------------------------------------------------------------------------------------------
			-- cleanup temporary directory
					
				cleanupFiles()
				
		)

		function init =
		(
			resetAll prompt:false
			tempFilePath	= sysinfo.tempdir + TEMP_DIR + "\\"
		)

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██                ██ ██                  
	--  ██  ██                ██ ██                  
	--  ██  ██ █████ █████ █████ ██ █████ ████ █████ 
	--  ██████    ██ ██ ██ ██ ██ ██ ██ ██ ██   ██    
	--  ██  ██ █████ ██ ██ ██ ██ ██ █████ ██   █████ 
	--  ██  ██ ██ ██ ██ ██ ██ ██ ██ ██    ██      ██ 
	--  ██  ██ █████ ██ ██ █████ ██ █████ ██   █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Handlers

		on btnSelect pressed do selectFiles()
		on btnCreate pressed do createFiles()
		on chkRun changed state do edtRun.enabled = state -- = edtScriptName.enabled = edtScriptDescription.enabled
		on btnHelp pressed do showHelp()
		on btnFile pressed do selectSaveFile()
		on btnPath pressed do selectSavePath()
		on btnOpen pressed do openSelectedFile()
		on btnDelete pressed do deleteSelectedFile()
		on btnReset pressed do resetAll()
		--on MzpCreator open do init()

)


rcmenu MzpMenu
(
	subMenu "Project"
	(
		menuItem miProjectNew "New..."
		menuItem miProjectOpen "Open..."
		separator spProject1
		menuItem miProjectImport "Import..."
		separator spProject2
		menuItem miProjectSaveAs "Save As..."
		menuItem miProjectSave "Save"
	)

	subMenu "Files"
	(
		menuItem miFilesSourceFiles "Add Source Files..."
		menuItem miFilesSourceFolder "Add Source Folder..."
		separator spFiles1
		menuItem miFilesExport "Choose Output File..."
		separator spFiles2
		menuItem miFiles "Export .mzp"
	)

	subMenu "Startup Script"
	(
		menuItem miScriptNew "New..."
		menuItem miScriptEdit "Edit..."
		separator spScript1
		menuItem miScriptImport "Import..."
		separator spScript2
		menuItem miScriptHelp "Help on Startup Scripts..."
	)

	subMenu "Tools"
	(
		menuItem miToolsExtract "Extract Existing .mzp..."
		menuItem miToolsOptions "Options..."
	)
	
	on miFilesSourceFiles picked do MzpCreator.selectFiles()
)

createDialog MzpCreator menu:MzpMenu


/*
s = getSaveFileName()
messagebox s
*/