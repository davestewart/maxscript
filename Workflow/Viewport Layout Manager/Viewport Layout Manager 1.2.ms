--------------------------------------------------------------------------------------------------------
--
-- Script:		Viewport Layout Manager
-- Version:		1.2
-- Date:		4 Sept 2006
-- Max version:	7, 8 +
--
-- Author:		Dave Stewart
-- Website:		www.davestewart.co.uk
--
--------------------------------------------------------------------------------------------------------
/* Description:	

Adds a new toolbar, containing a dropdown that allows you to change viewport layouts on the fly.

Features:

	· Change viewport layout on the fly
	· Save layout set
	· Change viewport layout on the fly

Stores and retrieves *per view*:

	· View type / named camera
	· Perpective view's viewpoint
	· Shading mode
	· Safe frame
	· Grid state
	· Bg image
	· Bg display
	· Active viewport

Options:

	· Quick background image on / off
	· Reset layout / all layouts
	· Save / load settings to file
	· Auto-dock to top or bottom
	· Auto-start with max
	· Clear settings on startup


Installation:

	Run this .ms file once and it will install Views-ViewportLayoutManager.mcr to the 3dsmax/UI/MacroScripts directory.


*/
--------------------------------------------------------------------------------------------------------


macroScript ViewportLayoutManager

	category:"Views"
	tooltip:"Viewport Layout Manager"
	icon:#("VPort_layout", 14)
	
(
	
		global roViewportLayout
		local printDebugInfo = false
	
		try (destroydialog roViewportLayout)
		catch(err)
	
		rollout roViewportLayout "Viewport Layout Manager" width:270 height:40
		(
		
			--------------------------------------------------------------------------------------------
			-- interface
			--------------------------------------------------------------------------------------------
			
			dropdownList ddlLayouts "" pos:[0,6] width:208 height:21
			--checkButton ckbBg "Bg" pos:[212,5] width:20 height:20
			button btnBg "Bg" pos:[212,6] width:20 height:20 toolTip:"Toggle viewport background on / off"
			button btnCfg "Cfg" pos:[232,6] width:20 height:20 toolTip:"Open Viewport Background dialog..."
				
			--------------------------------------------------------------------------------------------
			-- variables
			--------------------------------------------------------------------------------------------
		
				local vpt
				local shading
				local safeFrameOn
				local gridOn
				local bgImageOn
				local bgImage
				local viewTM
				
				local defaultTM = (matrix3 [0.707107,0.353553,-0.612372] [-0.707107,0.353553,-0.612372] [0,0.866025,0.5] [0,0,-250])
				local activeVpt
	
				local iniFile			= "$max/viewportLayout.ini"
				local iniString, iniArr
	
				local autoStart
				local autoStartFile		= "$max/scripts/startup/ViewportLayoutManager_startup.ms"
				local autoStartString	= "macros.run \"Views\" \"ViewportLayoutManager\""
	
				local dockPosition
		
				global mnViewportLayout
				
				local allowableViews = #(
					#view_left, 
					#view_right, 
					#view_top, 
					#view_bottom, 
					#view_front, 
					#view_back, 
					#view_iso_user, 
					#view_persp_user, 
					#view_camera, 
					#view_grid, 
					#view_none, 
					#view_spot, 
					#view_shape
				)
		
				local vptOptions = #(
					#(#layout_4,	"4 viewports - all same size"),
					#(undefined,	"--------------------------------------------------------------------------------------"),
					#(#layout_4vl,	"4 viewports - 3 on left, 1 on right"),
					#(#layout_4vr,	"4 viewports - 1 on left, 3 on right"),
					#(#layout_4ht,	"4 viewports - 3 on top, 1 on bottom"),
					#(#layout_4hb,	"4 viewports - 1 on top, 3 on bottom"),
					#(undefined,	"--------------------------------------------------------------------------------------"),
					#(#layout_3vl,	"3 viewports - 2 on left, 1 on right"),
					#(#layout_3vr,	"3 viewports - 1 on left, 2 on right"),
					#(#layout_3ht,	"3 viewports - 2 on top, 1 on bottom"),
					#(#layout_3hb,	"3 viewports - 1 on top, 2 on bottom"),
					#(undefined,	"--------------------------------------------------------------------------------------"),
					#(#layout_2v,	"2 viewports - vertical split, both same size"),
					#(#layout_2h,	"2 viewports - horizontal split, both same size"),
					#(#layout_2ht,	"2 viewports - horizontal split, top smaller"),
					#(#layout_2hb,	"2 viewports - horizontal split, top larger"),
					#(undefined,	"--------------------------------------------------------------------------------------"),
					#(#layout_1,	"1 viewport")
				)

				local vptDefaults = #(
					#(#layout_4,	#view_top,		#view_right,	#view_front,	#view_persp_user	),
					#(#layout_4vl,	#view_top,		#view_front,	#view_left,		#view_persp_user	),
					#(#layout_4vr,	#view_top,		#view_front,	#view_left,		#view_persp_user	),
					#(#layout_4ht,	#view_top,		#view_front,	#view_left,		#view_persp_user	),
					#(#layout_4hb,	#view_persp_user,#view_top,		#view_front,	#view_left			),
					#(#layout_3vl,	#view_top,		#view_front,	#view_persp_user	),
					#(#layout_3vr,	#view_top,		#view_front,	#view_persp_user	),
					#(#layout_3ht,	#view_top,		#view_left,		#view_persp_user	),
					#(#layout_3hb,	#view_top,		#view_left,		#view_persp_user	),
					#(#layout_2v,	#view_top,		#view_persp_user	),
					#(#layout_2h,	#view_left,		#view_persp_user	),
					#(#layout_2ht,	#view_left,		#view_persp_user	),
					#(#layout_2hb,	#view_top,		#view_left			),
					#(#layout_1,	#view_persp_user)
				)
			
	
			--------------------------------------------------------------------------------------------
			-- functions
			--------------------------------------------------------------------------------------------
		
				fn updateDropdown layout =
				(
					local index = 0
					while index == 0 do
					(
						for i = 1 to vptOptions.count do
						(
							if vptOptions[i][1] == layout then index = i
							exit
						)
					)
					ddlLayouts.selection = index
				)
					
				fn resetLayout =
				(
					-- get default views
						local layoutName = viewport.getLayout()
						local arrViews
						for arr in vptDefaults where arr[1] == layoutName do
						(
							arrViews = copy arr #nomap
							deleteItem arrViews 1
						)
					-- reset views
						for i = 1 to viewport.numViews do
						(
							-- view
								viewport.activeViewport = i
								
							-- view type
								if (viewport.getType()) != arrViews[i] then viewport.setType arrViews[i]
							
							-- other settings
								if arrViews[i] == #view_persp_user then 
								(
									viewport.setRenderLevel #smoothhighlights
									viewport.setTM defaultTM
								)
								else
								(
									viewport.setRenderLevel #wireFrame
								)
								
								viewport.DispBkgImage 	= false
								displaySafeFrames 		= false
								viewport.setGridVisibility i true
						)
				)
					
					
				function debug i vpt shading safeFrame gridOn bgImageOn bgImage viewTM =
				(
					if printDebugInfo then
					(
						format "\n"
						format "	view %:			%\n" i vpt
						format "		shading:	%\n" shading
						format "		safeFrame:	%\n" safeFrame
						format "		gridOn:		%\n" gridOn
						format "		bgImageOn:	%\n" bgImageOn
						format "		bgImage		%\n" bgImage
						format "		viewTM:		%\n" viewTM
					)
				)
					
				function saveSettings =
				(
					-- variables
						local layout		= viewport.getLayout()
						local oldActiveVpt	= viewport.activeViewport
						
					-- debug
						--format "Saving layout: %\n" layout
						
					-- get views
						for i = 1 to viewport.numViews do
						(
							-- view
								viewport.activeViewport = i
								
							-- view type
								vpt = viewport.gettype()
								if vpt == #view_camera then vpt = (viewport.getCamera()).name
							
							-- other settings
								shading			= viewport.GetRenderLevel()
								safeFrame		= if displaySafeFrames then 1 else 0
								gridOn			= if (viewport.GetGridVisibility i) then 1 else 0
								bgImageOn		= if viewport.DispBkgImage then 1 else 0
								bgImage			= backgroundImageFileName
								viewTM			= if vpt == #view_iso_user OR vpt == #view_persp_user then (viewport.getTM()) else ""
								
								iniString	= 	vpt as string +"|"+ 
												shading as string +"|"+ 
												safeFrame as string +"|"+ 
												gridOn as string +"|"+ 
												bgImageOn as string +"|"+ 
												bgImage as string +"|"+ 
												viewTM as string
								
							-- debug
								debug i vpt shading safeFrame gridOn bgImageOn bgImage viewTM
								
							-- ini setting
								setINISetting iniFile layout (i as string) iniString
						)
					-- ini setting
						setINISetting iniFile layout "activeVpt" (oldActiveVpt as string)
		
					-- cleanup
						viewport.activeViewport = oldActiveVpt
				)
		
				function loadSettings =
				(
					
					-- variables
						local layout		= viewport.getLayout()
						local oldActiveVpt	= viewport.activeViewport
		
					-- debug
						format "Loading layout: %\n" layout
						
					-- get views
						for i = 1 to viewport.numViews do
						(

							-- view
								viewport.activeViewport = i
								
							-- ini setting
								iniString		= getINISetting iniFile layout (i as string)
								iniArr			= filterstring iniString "|"
							
							-- variables
								vpt				= iniArr[1]
								shading			= iniArr[2]
								safeFrame		= iniArr[3]
								gridOn			= iniArr[4]
								bgImageOn		= iniArr[5]
								bgImage			= iniArr[6]
								viewTM			= iniArr[7]

							-- debug
								debug i vpt shading safeFrame gridOn bgImageOn bgImage viewTM
								
							-- view type
								if vpt != undefined AND vpt != "" then
								(
									if finditem allowableViews (vpt as name) != 0 then viewport.settype (vpt as name)
									else
									(
										local cam = getNodeByName vpt
										if cam != undefined then viewport.setCamera cam
									)
								)
							--messagebox (vpt as string)
								
							-- other settings
								if shading != undefined AND shading != "" then viewport.setRenderLevel(shading as name)
								if safeFrame != undefined AND safeFrame != "" then displaySafeFrames = if safeFrame == "1" then true else false
								if bgImageOn != undefined AND bgImageOn != "" then viewport.DispBkgImage = if bgImageOn == "1" then true else false
								if bgImage != undefined AND bgImage != "" then
								(
									if doesfileexist bgImage then backgroundImageFileName = bgImage
								)
								if viewTM != undefined then
								(
									--print "Setting viewport..."
									execute ("vptMatrix = " + viewTM)
									try(viewport.setTM vptMatrix)
									catch(
										format "Could not set viewport matrix...\n"
									)
								)
								else
								(
									--print ("View TM undefined: " + viewTM as string)
								)
								
								
						)
							
					-- cleanup
						local oldActiveVpt = getINISetting iniFile layout "activeVpt"
						viewport.activeViewport = if oldActiveVpt != "" then (oldActiveVpt as integer) else 1
						--checkVptBgState()
						activeVpt = viewport.activeViewport
						--checkVptBgState()
						
					-- view
						if objects.count == 0 then max tool zoomextents all

				)
				
				function clearAllSettings force:false =
				(
					if querybox "This will delete all saved settings, for all viewport layouts. Are you sure this is what you want to do?" then
					(
						for option in vptOptions do
						(
							if option[1] != undefined then delIniSetting iniFile option[1]
						)
					)
					resetLayout()
				)
		

			--------------------------------------------------------------------------------------------
			-- UI stuff
			--------------------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------------
			-- docking
			
				fn setDockDialog dp =
				(
					--messagebox "Set Dock"
					if dp == #cui_dock_top then
					(
						mnViewportLayout.miDockTop.checked = true
						mnViewportLayout.miDockBottom.checked = false
					)
					else
					(
						mnViewportLayout.miDockTop.checked = false
						mnViewportLayout.miDockBottom.checked = true
					)
					dockPosition = dp
					cui.DockDialogBar roViewportLayout (dockPosition as name)
					--messagebox ("Set ini: " +(dockPosition as string))
	
					setIniSetting iniFile "Settings" "dockPosition" dockPosition
				)
					
				fn getDockDialog =
				(
					--messagebox "Get Dock"
					dp = getIniSetting iniFile "Settings" "dockPosition"
					if dp == "" then dp = #cui_dock_top else dp = dp as name
					setDockDialog dp
				)
			
			-------------------------------------------------------------------------------------
			-- autostart
			
				fn setAutoStart state =
				(
					messagebox (state as string)
					mnViewportLayout.miAutoStart.checked = state
					if state then
					(
						local f	= openfile autoStartFile mode:"w"
						format autoStartString to:f
						close f
					)
					else
					(
						deleteFile autoStartFile
					)
				)	
	
				fn getAutoStart =
				(
					local files	= getFiles autoStartFile 
					autoStart = files.count == 1
					mnViewportLayout.miAutoStart.checked = autoStart
				)	
		
			-------------------------------------------------------------------------------------
			-- clear settings
			
				fn getClearSettings =
				(
					local iniSetting = getIniSetting iniFile "settings" "clearSettingsOnStartup"
					mnViewportLayout.miAutoClearSettings.checked = (iniSetting == "1")
					if iniSetting == "0" then clearSettings prompt:false
				)	
		
				fn setClearSettings state =
				(
					mnViewportLayout.miAutoClearSettings.checked = state
					setIniSetting iniFile "settings" "clearSettingsOnStartup" (if state then "1" else "0")
				)

			-------------------------------------------------------------------------------------
			-- export settings

				fn importSettingsFile =
				(
					-- open file
						local iniCopy = getOpenFileName "Import Viewport Layout settings file" types:"Viewport Settings file(*.vpt.ini)|*.vpt.ini"
						if iniCopy != undefined then
						(
							copyFile iniCopy iniFile
						)
					-- settings
						loadSettings()
				)
					
				fn exportSettingsFile =
				(
					-- settings
						saveSettings()
					-- get base name
						local ext		= ".vpt.ini"
						local fileName	= maxFileName
						local badChars	= filterstring " ,0,1,2,3,4,5,6,7,9,8,9" ","
						try
						(
							fileName = substring fileName 1 ((findstring fileName ".max") - 1)
							while (finditem badChars (fileName[fileName.count]))> 0 do fileName = substring fileName 1 (fileName.count - 1)
						)
						catch()
						fileName = fileName + " viewport settings"
					-- get save file
						--local iniCopy = getSaveFileName "Export Viewport Layout settings file" filename:fileName types:"Viewport Settings file(*.vpt.ini)|*.vpt.ini"
						local iniCopy = getSaveFileName "Export Viewport Layout settings file" filename:fileName types:("Settings file(*" +ext+ ")|*" +ext)
						if iniCopy != undefined then
						(
							-- edit name if double ".vpt.ini"
							while (i = findstring iniCopy ext) != undefined do
							(
								iniCopy = replace iniCopy i ext.count ""
							)
							iniCopy += ext
							copyFile iniFile iniCopy
						)
				)

			-------------------------------------------------------------------------------------
			-- right click menu
			
				fn initRightClickMenu =
				(
					rcmenu mnViewportLayout
					( 
					
						-- interface
							menuItem miVptDialog "Viewport Background..."
							separator sep_1
							menuItem miClearSettings "Clear Settings for This Layout"
							menuItem miClearAllSettings "Clear Settings for ALL Layouts"
							separator sep_2
							menuItem miImportSettings "Import Layout Set..."
							menuItem miExportSettings "Export Layout Set..."
							separator sep_3
							menuItem miDockTop "Dock at Top"
							menuItem miDockBottom "Dock at Bottom"
							separator sep_4
							menuItem miAutoStart "Run Automatically on max Startup"
							menuItem miAutoClearSettings "Clear Settings on max Startup"
						
						-- handlers
							on miVptDialog picked do 			actionMan.executeAction 0 "40095"  -- Views: Viewport Background
							
							on miClearSettings picked do		resetLayout()
							on miClearAllSettings picked do		clearAllSettings()
	
							on miExportSettings picked do		exportSettingsFile()
							on miImportSettings picked do		importSettingsFile()
							
							on miDockTop picked do				setDockDialog #cui_dock_top
							on miDockBottom picked do			setDockDialog #cui_dock_bottom
							
							on miAutoStart picked do			setAutoStart (NOT miAutoStart.checked)
							on miAutoClearSettings picked do	setClearSettings (NOT miAutoClearSettings.checked)
							
					) 
					
					-- register the rcmenu 
						registerRightClickMenu mnViewportLayout
				)
	
			--------------------------------------------------------------------------------------------
			-- callback
			--------------------------------------------------------------------------------------------
		
				fn viewportLayoutManagerFileOpen_cb =
				(
					updateDropdown (viewport.getLayout())
				)
	
			--------------------------------------------------------------------------------------------
			-- handlers
			--------------------------------------------------------------------------------------------
		
				on ddlLayouts selected index do
				(
					try(
						if vptOptions[index][1] != undefined then
						(
							saveSettings()
							viewport.setLayout vptOptions[index][1]
							loadSettings()
							viewport.SetRenderLevel (viewport.getRenderLevel())
						)
						else updateDropdown (viewport.getLayout())
			
						enableSceneRedraw()
						forcecompleteredraw()
						redrawViews()
					)
					catch(
						updateDropdown (viewport.getLayout())
						messagebox "Could not change viewport layout! Is one of your viewports an extended view?"
					)
				)
					
				on btnBg pressed do
				(
					viewport.DispBkgImage = NOT viewport.DispBkgImage
					InvalidateAllBackgrounds()
					slidertime = slidertime -- hack to update bg
				)
			
				on btnCfg pressed do
				(
					popUpMenu mnViewportLayout
				)
		
		
				on roViewportLayout open do
				(
					-- dropdown
						ddlLayouts.items = for a in vptOptions collect a[2]
						updateDropdown (viewport.getLayout())
					-- vpt matrix
						global vptMatrix = defaultTM
					-- right click menu
						initRightClickMenu()
					-- autostart
						getAutoStart()
						getClearSettings()
					-- callback
						callbacks.addScript #filePostOpenProcess "roViewportLayout.viewportLayoutManagerFileOpen_cb()" id:#viewportLayoutManagerFileOpen
				)
					
				on roViewportLayout close do
				(
					-- callback
						callbacks.removeScripts id:#viewportLayoutManagerFileOpen
				)
					
					
		)
		-- create
			createdialog roViewportLayout style:#(#style_titlebar, #style_border, #style_sysmenu)
			cui.RegisterDialogBar roViewportLayout style:#(#cui_dock_top, #cui_dock_bottom, #cui_floatable)
		-- dock
			roViewportLayout.getDockDialog()
	
)

(
macros.run "Views" "ViewportLayoutManager"
messagebox "Viewport Layout Manager has been installed."
)





