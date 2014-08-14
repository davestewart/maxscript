try(destroydialog MzpCreator)catch()
rollout MzpCreator ".mzp Creator" width:432 height:520
(
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ##  ##            ##       ##    ##             
	--  ##  ##                     ##    ##             
	--  ##  ## ##### #### ## ##### ##### ## ##### ##### 
	--  ##  ##    ## ##   ##    ## ## ## ## ## ## ##    
	--  ##  ## ##### ##   ## ##### ## ## ## ##### ##### 
	--   ####  ## ## ##   ## ## ## ## ## ## ##       ## 
	--    ##   ##### ##   ## ##### ##### ## ##### ##### 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Variables

		-- varaiables

			-- anything with path, means it includes the full path with the name
			-- anything with name, or just file, or just folder, means it inludes only the name of the file or folder
	
			local APP_PATH				= ""
			local HELP_PATH				= "\\help\\"
			local SETTINGS_PATH			= ""
	
			local ZIP_EXE_FILE_PATH		= "bin\\zip.exe"				-- sits in a sub folder
			local TEMP_FOLDER_PATH		= ""							-- gets set to temp dir in the init() function
			local TEMP_FOLDER_NAME		= "mzp-creator-temp"			-- a given constant

			local SLEEP_TIME			= 2
		
			local runScriptPath
			local outputFilePath
			
			local fileSystemWatcher
			local lastFolder
			local files					= #()
		
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ##        ##               ####                   
	--  ##        ##               ##                     
	--  ## ##### ##### ##### ####  ##   ##### ##### ##### 
	--  ## ## ##  ##   ## ## ##   #####    ## ##    ## ## 
	--  ## ## ##  ##   ##### ##    ##   ##### ##    ##### 
	--  ## ## ##  ##   ##    ##    ##   ## ## ##    ##    
	--  ## ## ##  #### ##### ##    ##   ##### ##### ##### 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Interface

	GroupBox grpInfo "Project" pos:[8,8] width:416 height:120
		dotNetControl lvInfo "System.Windows.Forms.ListView" pos:[16,32] width:400 height:83
				
		dotNetControl lvFiles "System.Windows.Forms.ListView" pos:[16,160] width:400 height:160
		button btnAddFolder "Add Folder..." pos:[88,328] width:72 height:16
		button btnAddFiles "Add Files..." pos:[16,328] width:72 height:16
		checkbox chkFilesRecursive "Recursive" pos:[162,328] width:70 height:16 checked:true enabled:false 
		label lblStructure "Structure:" pos:[238,329] width:48 height:16 enabled:false
		radiobuttons rdoStructure "" pos:[288,329] width:149 height:16 labels:#("Flatten", "Preserve") columns:2 enabled:false 
	GroupBox grpSource "Source Files" pos:[8,136] width:416 height:216
				
	GroupBox grpScript "Startup Script (mzp.run)" pos:[8,360] width:416 height:48
		button btnCreateRunScript "Create..." pos:[16,384] width:72 height:16
		checkbox chkAddRun "Add 'run' entries for checked items above" pos:[90,384] width:220 height:16 checked:true
				
	GroupBox grpOutput "Output File" pos:[8,416] width:416 height:88
		edittext edtOutputFilePath "" pos:[13,440] width:384 height:18
		button btnSelectOutputFile "..." pos:[398,440] width:18 height:18 toolTip:"Choose output file..."
		button btnExportOutputFile "Export .mzp" pos:[16,464] width:400 height:32
		

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ##  ##  ##   ## ## ##  ##   ##             
	--  ##  ##  ##      ##     ##                  
	--  ##  ## ##### ## ## ## ##### ## ##### ##### 
	--  ##  ##  ##   ## ## ##  ##   ## ## ## ##    
	--  ##  ##  ##   ## ## ##  ##   ## ##### ##### 
	--  ##  ##  ##   ## ## ##  ##   ## ##       ## 
	--  ######  #### ## ## ##  #### ## ##### ##### 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Utilities

		fn getMultipleFiles =
	(
			local dialog		= dotNetObject "System.Windows.Forms.OpenFileDialog"
			
			dialog.title		= "Select one or more files to be included in the .mzp package"
			dialog.Filter		= "Script Files (*.ms, *.mcr, *.mse)|*.ms;*.mcr;*.mse|All Files (*.*)|*.*"
			dialog.Multiselect	= true
			dialog.FilterIndex	= 2

			local result		= dialog.showDialog()
			if result.Equals result.OK then dialog.fileNames else #()
	)
		
		fn readFile filePath =
	(
			local source	= ""
			local f			= openFile filePath more:"r"
			while not eof f do source += readline f + "\n"
			close f
			source
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
		
		fn removeQuotes str =
	(
			local arr = filterstring str "\""
			str = ""
			for a in arr do str += a
			str
	)
		
		fn regexMatch source pattern options: =
	(
			local groups
			local results	= #()
			local rx		= dotNetClass "System.Text.RegularExpressions.RegEx"
			local matches	= if options == unsupplied then rx.match source pattern else rx.match source pattern options
			while matches.Success do
		(
				groups		= for i = 1 to matches.Groups.count - 1 collect matches.groups.item[i].value
				matches		= matches.nextMatch()
				append results (if groups.count == 1 then groups[1] else groups)
		)
			results
	)

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ######             
	--  ##                 
	--  ##     ##### ##### 
	--  #####  ## ## ##    
	--  ##     ## ## ##### 
	--  ##     ## ##    ## 
	--  ##     ## ## ##### 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Fns

		fn command = ()
		
		fn itemIsChecked item subItem= 
	(
			return item.checked == true
	)
		
		fn showOptions =
	(
	)
		
		fn cleanupFiles =
	(
			local tempFiles = getFiles (TEMP_FOLDER_PATH + "\\*.*")
			for f in tempFiles do
		(
				deleteFile f
		)
	)

		fn getSourceFiles =
	(
			if lvFiles.items.count == 0 then
		(
				#()
		)
			else
		(
				for i = 0 to lvFiles.items.count - 1 collect lvFiles.items.item[i].tag
		)
	)

		
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ######                    ##   ##                   
	--  ##                        ##                        
	--  ##     ## ## ##### ##### ##### ## ##### ##### ##### 
	--  #####  ## ## ## ## ##     ##   ## ## ## ## ## ##    
	--  ##     ## ## ## ## ##     ##   ## ## ## ## ## ##### 
	--  ##     ## ## ## ## ##     ##   ## ## ## ## ##    ## 
	--  ##     ##### ## ## #####  #### ## ##### ## ## ##### 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Functions
		

		-- ------------------------------------------------------------------------------------------------------------------------
		-- tools
					
			function extractMzp =
		(
				messagebox "This feature is not yet implimented"
		)
			

		-- ------------------------------------------------------------------------------------------------------------------------
		-- project
					
			function openProject =
		(
		)
			
			function importProject =
		(
		)
			
			function saveProject as:true =
		(
		)
			
		-- ------------------------------------------------------------------------------------------------------------------------
		-- description
			
			function updateProperties arr =
		(
				DotNetListView.setColumnValues lvInfo 1 arr
		)
			
		-- ------------------------------------------------------------------------------------------------------------------------
		-- source files
			
			fn addSourceFile f =
		(
				if (findItem files f) == 0 do
			(
					-- variables
						local fileName, filePath

					-- add file
						fileName	= filenameFromPath f
						filePath	= getFileNamePath f
						DotNetListView.addRow lvFiles #(fileName, filePath) tags:#(f, undefined)
					
					-- update files
						files = getSourceFiles()
			)
		)
			
			
			function addSourceFiles =
		(
				local files = getMultipleFiles()
				if files.count > 0 then
			(
					for f in files do
				(
						addSourceFile f
				)
					lastFolder = getFilenamePath files[1]
			)
		)
			
			function addSourceFolder =
		(
				local initialDir	= if lastFolder == undefined then sysinfo.currentDir else lastFolder
				local folderPath	= getSavePath caption:"Choose a folder from which to import all files..." initialDir:initialDir
				if folderPath != undefined do
			(
					local files		= getFiles (folderPath + "\\*")
					if files.count > 0 then
				(
						for f in files do
					(
							addSourceFile f
					)
				)
			)
		)
			
			function editSourceFile item =
		(
				local fileName	= item.text
				local filePath	= item.subItems.item[1].text
				local file		= filePath + fileName
				
				local rx		= (dotNetClass "System.Text.RegularExpressions.Regex")
				local isScript	= rx.IsMatch file "\.(ms|mcr)$"
				
				if isScript then edit file else shelllaunch file
				
				item.checked = NOT item.checked
		)

			function deleteSelectedSourceFiles lv evt =
		(
				-- variables
					local selectedItems, item
					selectedItems = lvFiles.selectedItems
				
				-- delete
					for i = selectedItems.count - 1 to 0 by -1 do
				(
						item = selectedItems.item[i]
						item.remove()
				)
					
				-- update files
					files = getSourceFiles()

		)


		-- ------------------------------------------------------------------------------------------------------------------------
		-- startup script
			
			fn onRunScriptChanged source eventArgs =
		(
				--format "The file \"%\" has changed, change type is \"%\".\n" (getFilenameFile EventArgs.FullPath) (EventArgs.ChangeType.ToString())
					
				local source		= readFile EventArgs.FullPath
				local pattern		= "(\w+)\s+\"?([^\"\n]+)\"?"
				local matches		= regexMatch input pattern
				
				local arr			= #()
				for i = 1 to matches.count do
			(
					if matches[i][1] == "name" then arr[1] == matches[i][2]
					else if matches[i][1] == "description" then arr[2] == matches[i][2]
					else if matches[i][1] == "version" do arr[3] == matches[i][2]
			)
				
				--updateProperties arr
				print arr
		)
			

			function monitorRunScript folderPath =
		(
				print ("monitoring " + folderPath)
				fileSystemWatcher.Path					= folderPath
				fileSystemWatcher.EnableRaisingEvents	= true
				fileSystemWatcher.Filter				= "mzp.run"
		)
			
			function createRunScriptText =
		(
				-- variables
					local text		= ""
					local item
				
				-- info
					for i = 0 to lvInfo.items.count - 1 do
				(
						item = lvInfo.items.item[i]
						text += item.subItems.item[1].name + " \"" + (removeQuotes item.subItems.item[0].text) + "\"\n"
				)
				
				-- break
					text += "\n"
					
				-- files
					if chkAddRun.checked do
				(
						local item
						for i = 0 to lvFiles.items.count - 1 do
					(
							item = lvFiles.items.item[i]
							if item.checked do text += "run \"" + (filenameFromPath item.tag) + "\"\n"
					)
				)
					
				-- text
					print text
					text
		)

			function setRunScript filePath =
		(
				grpScript.text = "Startup Script"
				if filePath != undefined then
			(
					--local text					= shortenFilePath filePath maxLength:65 split:0.5 delimiter:"..."
					--grpScript.text				+= " (" + text + ")"
					btnCreateRunScript.text		= "Edit..."
			)
				else
			(
					btnCreateRunScript.text		= "Create..."
			)
				
				btnCreateRunScript.tooltip	= if filePath != undefined then filePath else ""
				runScriptPath				= filePath
				if runScriptPath != undefined do monitorRunScript (getFilenamePath runScriptPath)
		)
			
			function isRunScript =
		(
				runScriptPath != undefined AND doesFileExist runScriptPath
		)
			
			function editRunScript =
		(
				if isRunScript() then
			(
					edit runScriptPath
					true
			)
				else
			(
					false
			)
		)
			
			function createRunScript =
		(
				local runScriptText, runScriptFile
				local filePath = getSaveFileName caption:"Choose the folder where you want the mzp.run file to be saved..." filename:"mzp.run"
				if filePath != undefined do
			(
					runScriptText	= createRunScriptText()
					runScriptFile	= createFile filePath
					format runScriptText to:runScriptFile
					close runScriptFile
					setRunScript filePath
			)
		)
			
			function openRunScript =
		(
				filePath = getOpenFileName caption:"Select the new mzp.run file..." filename:"mzp.run" types:"Startup Script (mzp.run)|*.run|All (*.*)|*.*|"
				if doesFileExist filePath do
			(
					setRunScript filePath
					editRunScript()
			)
		)
			
			function importRunScript =
		(
		)
			
		-- ------------------------------------------------------------------------------------------------------------------------
		-- output
			
			function selectOutputFile =
		(
				local filePath = getSaveFileName types:"Zip-file Script Packages (*.mzp)|*.mzp" caption:"" filename:((DotNetListView.getCellValue lvInfo 0 0) + ".mzp")

				if filePath != undefined do
			(
					edtOutputFilePath.text = filePath
					outputFilePath = filePath
			)
		)
		
			function createOutputFile =
		(
				
				try
			(
					--------------------------------------------------------------------------------------------------------------------------
					-- setup
					
						-- variables
							local zipParams				= ""
							local zipExeFilePath		= TEMP_FOLDER_PATH + "zip.exe"
							local zipFilePath			= TEMP_FOLDER_PATH + "tmp.zip"
							
					--------------------------------------------------------------------------------------------------------------------------
					-- copy all files
							
						-- make dir
							if makeDir TEMP_FOLDER_PATH == false do
						(
								messagebox ("The folder '" +TEMP_FOLDER_PATH+ "' could not be created / found. Aborting...")
								return false
						)
						
						-- copy all the files
							-- this needs to reflect the structure radio!
							try
						(
								local files = getSourceFiles()
								for f in files do
							(
									copyFile f  (TEMP_FOLDER_PATH + (filenameFromPath f))
									zipParams += " \"" + (filenameFromPath f) +"\" " 
							)
						)
							catch
						(
								messagebox ("There was a problem copying the source files to the temporary directory. Aborting...")
								return false
						)
							
						-- copy the run file
							try
						(
								if isRunScript() do
							(
									copyFile runScriptPath  (TEMP_FOLDER_PATH + (filenameFromPath runScriptPath))
									zipParams += " mzp.run "
							)
						)
							catch
						(
								messagebox ("There was a problem copying the Auto Start script to the temporary directory. Aborting...")
								return false
						)
							
						-- copy the zip.exe
							print #(ZIP_EXE_FILE_PATH, zipExeFilePath)
							if NOT doesFileExist zipExeFilePath do
						(
								if (copyFile ZIP_EXE_FILE_PATH zipExeFilePath == false) do
							(
									messagebox ("There was a problem copying the Zip application to the temporary directory. Aborting...")
									return false
							)
						)
					
					--------------------------------------------------------------------------------------------------------------------------
					-- do the zipping
							
						-- create the text to zip the file
							zipParams = " \"" +(filenameFromPath zipFilePath)+ "\"" +zipParams
							format "Zipping... % %\n" zipExeFilePath zipParams
							
						-- create file
							try
						(
								shellLaunch zipExeFilePath zipParams
						)
							catch
						(
								messagebox ("There was a problem launching the Zip application. Aborting...")
								return false
						)

						-- delete any existing file
							deleteFile outputFilePath
							
						-- rename and move the zip file(after a tiny sleep to make sure all files have been created)
							sleep SLEEP_TIME
							renameFile zipFilePath outputFilePath
							
					--------------------------------------------------------------------------------------------------------------------------
					-- cleanup temporary directory
							
						cleanupFiles()
							
					--------------------------------------------------------------------------------------------------------------------------
					-- Done
							
						return true
			)
				catch
			(
					return false
			)

					
		)
			
			function exportOutputFile =
		(
				-- check
					if files.count == 0 do
				(
						messagebox "You haven't selected any source files"
						return false
				)
				
				-- output
					if outputFilePath == undefined do selectOutputFile()
					if outputFilePath != undefined do
				(
						if createOutputFile() then
					(
							--messagebox ("The zipping process completed successfully!")
							shellLaunch "explorer.exe" ("/select, \"" + outputFilePath +"\"")
					)
				)
		)
			



		
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ######          ##       
	--  ##              ##       
	--  ##     ##### ##### ##### 
	--  ##     ## ## ## ## ## ## 
	--  ##     ## ## ## ## ##### 
	--  ##     ## ## ## ## ##    
	--  ###### ##### ##### ##### 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Code
		
		-- ------------------------------------------------------------------------------------------------------------------------
		-- init
			
			function resetAll prompt:false clearInfo:false=
		(
				local state = if prompt then querybox "Are you sure you want to discard the current project?" else true
				if state do
			(
					files					= #()
					
					edtOutputFilePath.text	= ""
					
					try
				(
						lvInfo.items.clear()
						lvFiles.items.clear()
				)
					catch()
					
					if clearInfo then
				(
						DotNetListView.addRow lvInfo #("", "Name") names:#("name", "name")
						DotNetListView.addRow lvInfo #("", "Description") names:#("description", "description")
						DotNetListView.addRow lvInfo #("", "Version") names:#("version", "version")
				)
					else
				(
						DotNetListView.addRow lvInfo #("Script Name", "Name") names:#("name", "name")
						DotNetListView.addRow lvInfo #("What does it do?", "Description") names:#("description", "description")
						DotNetListView.addRow lvInfo #("1.0", "Version") names:#("version", "version")
				)

			)
		)

			function init =
		(
				-- debug
					print ("Starting in : " + sysinfo.currentdir)
				
				-- variables
					local lv, props

					APP_PATH							= sysinfo.currentdir
					HELP_PATH							= APP_PATH --+ "\\help\\"
					SETTINGS_PATH						= APP_PATH + "\\settings\\"
					ZIP_EXE_FILE_PATH					= APP_PATH + "\\" + ZIP_EXE_FILE_PATH
					TEMP_FOLDER_PATH					= sysinfo.tempdir + TEMP_FOLDER_NAME + "\\"
				
				-- reset
					resetAll()

				-- properties
					lv									= lvInfo
					props								= #(#gridLines, #labelEdit, #FullRowSelect)

					DotNetListView.addColumns lv #("Value", "Property") #(500, 100)
					DotNetListView.setProperties lv props true

					lv.columns.item[1].displayIndex		= 0
					lv.Refresh()

				-- files
					lv									= lvFiles
					props								= #(#gridLines, #checkBoxes, #labelEdit, #FullRowSelect, #AutoSize, #FullRowSelect)

					DotNetListView.addColumns lv #("Name","Path") #(150,450)
					DotNetListView.setProperties lv props true
					
				-- watch file system
					fileSystemWatcher					= dotNetobject "System.IO.FileSystemWatcher"
					dotNet.addEventHandler fileSystemWatcher "Changed" onRunScriptChanged


		)
			
			function deinit =
		(
				-- stop watching file system
					dotNet.removeAllEventHandlers FileSystemWatcher
					fileSystemWatcher.EnableRaisingEvents = false
					fileSystemWatcher.Dispose()
		)



	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ##  ##                ## ##                  
	--  ##  ##                ## ##                  
	--  ##  ## ##### ##### ##### ## ##### #### ##### 
	--  ######    ## ## ## ## ## ## ## ## ##   ##    
	--  ##  ## ##### ## ## ## ## ## ##### ##   ##### 
	--  ##  ## ## ## ## ## ## ## ## ##    ##      ## 
	--  ##  ## ##### ## ## ##### ## ##### ##   ##### 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Handlers

		on btnAddFolder pressed do addSourceFolder()
		on btnAddFiles pressed do addSourceFiles()
			
		on btnCreateRunScript pressed do
	(
			if runScriptPath == undefined then createRunScript() else editRunScript()
	)
			
		on btnSelectOutputFile pressed do selectOutputFile()
		on btnExportOutputFile pressed do exportOutputFile()
		
		on rdoStructure changed state do command()
		
		on lvFiles MouseDoubleClick evt do
	(
			editSourceFile (lvFiles.GetItemAt evt.x evt.y)
	)
		
	   on lvFiles ControlRemoved e do messagebox "Deleting"

		on lvFiles KeyUp evt do DotNetListView.keyUp lvFiles evt onDelete:deleteSelectedSourceFiles
		
		on MzpCreator open do init()
)

rollout MzpCreatorHelp ".mzpCreator Help" width:600 height:600
( 
	-- ------------------------------------------------------------------------------------------------------------------------
	-- interface

		dotNetControl web "System.Windows.Forms.WebBrowser" height:280 width:200 pos:[0,0]
		
	-- ------------------------------------------------------------------------------------------------------------------------
	-- functions

		function show url =
	(
			print url
			try(destroydialog MzpCreatorHelp)catch()
			createDialog MzpCreatorHelp	style:#(#style_resizing, #style_minimizebox, #style_maximizebox, #style_titlebar, #style_sysmenu)
			MzpCreatorHelp.resized (getdialogsize MzpCreatorHelp)
			web.Navigate url
	)
		
		function showMainHelp =
	(
			show (MzpCreator.HELP_PATH + "help.html")
	)
		
		function showScriptHelp =
	(
			show ("mk:@MSITStore:" + (getdir #help) + "\maxscript.chm::/Zip_file_Script_Packages.htm")
	)
		
		function showShortcutsHelp =
	(
			show (MzpCreator.HELP_PATH + "shortcuts.html")
	)
		
		
	-- ------------------------------------------------------------------------------------------------------------------------
	-- handlers

		on MzpCreatorHelp open do 
	(
			--web.ScrollBarsEnabled = false
	)
		
		
		on MzpCreatorHelp resized size do
	(
			web.width = size[1]
			web.height = size[2]
	)
	
)


rcmenu MzpMenu
(
	fn checkRunScriptPath = MzpCreator.runScriptPath != undefined
	
	subMenu "Project"
(
		menuItem miProjectNew "New..."
		menuItem miProjectOpen "Open..." enabled:false
		separator spProject1
		menuItem miProjectImport "Import..." enabled:false
		separator spProject2
		menuItem miProjectSaveAs "Save As..." enabled:false
		menuItem miProjectSave "Save" enabled:false
)

	subMenu "Files"
(
		menuItem miFilesAddSourceFiles "Add Source Files..."
		menuItem miFilesAddSourceFolder "Add Source Folder..."
		separator spFiles1
		menuItem miFilesSelectOutputFile "Select Output File..."
		separator spFiles2
		menuItem miFilesExport "Export .mzp"
)

	subMenu "Startup Script"
(
		menuItem miScriptNew "New..."
		menuItem miScriptOpen "Open..."
		menuItem miScriptEdit "Edit..." enabled:(checkRunScriptPath())
		separator spScript1
		menuItem miScriptImport "Import..." enabled:false
		separator spScript2
		menuItem miScriptHelp "Help on Startup Scripts..."
)

	subMenu "Tools"
(
		menuItem miToolsExtract "Extract Existing .mzp..." enabled:false
)
	
	subMenu "Help"
(
		menuItem miHelpMain "Introduction..."
		menuItem miHelpScripts "Help on Startup Scripts..."
		menuItem miHelpKeyboardShortcuts "Keyboard and Mouse Shortcuts..."
)
	
	on miProjectNew picked do MzpCreator.resetAll prompt:true clearInfo:true
	on miProjectOpen picked do MzpCreator.openProject()
	on miProjectImport picked do MzpCreator.importProject()
	on miProjectSaveAs picked do MzpCreator.saveProject as:true
	on miProjectSave picked do MzpCreator.saveProject()
	
	on miFilesAddSourceFiles picked do MzpCreator.addSourceFiles()
	on miFilesAddSourceFolder picked do MzpCreator.addSourceFolder()
	on miFilesSelectOutputFile picked do MzpCreator.selectOutputFile()
	on miFilesExport picked do  MzpCreator.exportOutputFile()
	
	on miScriptNew picked do MzpCreator.createRunScript()
	on miScriptOpen picked do MzpCreator.openRunScript()
	on miScriptEdit picked do MzpCreator.editRunScript()
	on miScriptImport picked do MzpCreator.importRunScript()
	on miScriptHelp picked do MzpCreatorHelp.showScriptHelp()
	
	on miToolsExtract picked do MzpCreator.command()
	on miToolsOptions picked do MzpCreator.showOptions()

	on miHelpMain picked do MzpCreatorHelp.showMainHelp()
	on miHelpScripts picked do MzpCreatorHelp.showScriptHelp()
	on miHelpKeyboardShortcuts picked do MzpCreatorHelp.showShortcutsHelp()
)

createDialog MzpCreator menu:MzpMenu
