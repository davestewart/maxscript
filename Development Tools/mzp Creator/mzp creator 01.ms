try(destroydialog roMzpCreator)catch()
rollout roMzpCreator ".mzp Creator" width:376 height:520
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

		GroupBox grpSource "Input Files" pos:[8,8] width:360 height:64
			button btnSelect "Choose files..." pos:[16,24] width:288 height:16
			checkbox chkAppend "Append" pos:[309,24] width:56 height:16
			dropdownList ddlFiles "" pos:[16,44] width:290 height:21
			button btnOpen ">" pos:[308,45] width:18 height:18 toolTip:"Open file"
			button btnDelete "x" pos:[326,45] width:18 height:18 toolTip:"Delete file"
			button btnReset "R" pos:[344,45] width:18 height:18 toolTip:"Reset utility"
			
		GroupBox grpOptions "Startup Script (mzp.run)" pos:[8,80] width:360 height:216
			edittext edtRun "" pos:[12,96] width:348 height:176
			checkbox chkRun "Use a startup script" pos:[33,276] width:110 height:16 checked:true
			button btnHelp "?" pos:[16,276] width:14 height:14 toolTip:"Reset utility"

		GroupBox grpProperties "Script Information (included in the head of mzp.run)" pos:[8,304] width:360 height:88
			edittext edtScriptName "Name" pos:[17,322] width:343 height:18
			edittext edtScriptDescription "Desc" pos:[19,342] width:341 height:44
			
		GroupBox grpOutput "Output File" pos:[8,400] width:360 height:112
			edittext edtFileName "Name" pos:[16,416] width:325 height:18
			edittext edtFilePath "Path" pos:[21,440] width:320 height:18
			button btnPath "<" pos:[342,440] width:18 height:18
			button btnCreate "Create mzp" pos:[16,469] width:344 height:32
			button btnFile "<" pos:[342,416] width:18 height:18
		
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
				edtFileName.text = ""
				edtFilePath.text = ""
				setDescriptiveText filePath
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
		on roMzpCreator open do init()

)

createDialog roMzpCreator