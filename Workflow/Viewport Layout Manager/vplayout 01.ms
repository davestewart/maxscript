try (destroydialog roViewportLayout);catch(err)
rollout roViewportLayout "Viewport Layout" width:274 height:32
(

	--------------------------------------------------------------------------------------------
	-- interface
	--------------------------------------------------------------------------------------------
	
		dropdownList ddlLayouts "" pos:[4,4] width:208 height:21
		button btnReset "Reset" pos:[216,4] width:40 height:20
		

	--------------------------------------------------------------------------------------------
	-- variables
	--------------------------------------------------------------------------------------------

		local iniFile	= "$max/viewportLayout.ini"
		
		local vpOptions = #(
			#(#layout_1,	"1 viewport"),
			#(undefined,	"--------------------------------------------------------------------------------------"),
			#(#layout_2v,	"2 viewports - vertical split, both same size"),
			#(#layout_2h,	"2 viewports - horizontal split, both same size"),
			#(#layout_2ht,	"2 viewports - horizontal split, top smaller"),
			#(#layout_2hb,	"2 viewports - horizontal split, top larger"),
			#(undefined,	"--------------------------------------------------------------------------------------"),
			#(#layout_3vl,	"3 viewports - 2 on left, 1 on right"),
			#(#layout_3vr,	"3 viewports - 1 on left, 2 on right"),
			#(#layout_3ht,	"3 viewports - 2 on top, 1 on bottom"),
			#(#layout_3hb,	"3 viewports - 1 on top, 2 on bottom"),
			#(undefined,	"--------------------------------------------------------------------------------------"),
			#(#layout_4,	"4 viewports - all same size"),
			#(#layout_4vl,	"4 viewports - 3 on left, 1 on right"),
			#(#layout_4vr,	"4 viewports - 1 on left, 3 on right"),
			#(#layout_4ht,	"4 viewports - 3 on top, 1 on bottom"),
			#(#layout_4hb,	"4 viewports - 1 on top, 3 on bottom")
			)
	
	
	--------------------------------------------------------------------------------------------
	-- functions
	--------------------------------------------------------------------------------------------

			
		function updateDropdown layout =
			(
			local index = 0
			while index == 0 do
				(
				for i = 1 to vpOptions.count do
					(
					if vpOptions[i][1] == layout then index = i
					)
				)
			ddlLayouts.selection = index
			)
			
			
		function saveSettings =
			(
			-- variables
				local layout		= viewport.getLayout()
				local oldActiveView = viewport.activeViewport
				
				local vpt
				local shading
				local safeFrame
				local bgImageOn
				local bgImage
				local iniString
				
			-- get views
				disableSceneRedraw()
				for i = 1 to viewport.numViews do
					(
					-- settings
						viewport.activeViewport = i
						vpt = viewport.gettype()
						if vpt == #view_camera then vpt = (viewport.getCamera()).name
					
					-- shading
						shading		= viewport.GetRenderLevel()
						safeFrame	= displaySafeFrames
						bgImageOn	= viewport.DispBkgImage 
						bgImage		= backgroundImageFileName
						iniString	= 	vpt +"|"+ 
										shading +"|"+ 
										safeFrame +"|"+ 
										bgImageOn +"|"+ 
										bgImage
						
					setINISetting iniFile layout (i as string) iniString
					)
				viewport.activeViewport = oldActiveView
				enableSceneRedraw()

			)
		
		function loadSettings =
			(
			for i = 1 to viewport.numViews do
				(
				activeview = i
				vpt = viewport.gettype()
				if vpt == #view_camera then
					(
					cam = viewport.getCamera()
					print cam.name
					)
				else
					(
					print vpt
					)
				)
			)


			
	--------------------------------------------------------------------------------------------
	-- handlers
	--------------------------------------------------------------------------------------------

		on ddlLayouts selected index do
			(
			if vpOptions[index][1] != undefined then
				(
				saveSettings()
				viewport.setLayout vpOptions[index][1]
				)
			else updateDropdown (viewport.getLayout())
			)
			
		on btnReset pressed do
			(
			viewport.setLayout #layout_4
			updateDropdown #layout_4
	
			)
	
		on roViewportLayout open do
			(
			ddlLayouts.items = for a in vpOptions collect a[2]
			updateDropdown (viewport.getLayout())
			)
			
	)
createdialog roViewportLayout style:#(#style_titlebar, #style_border, #style_sysmenu)
cui.RegisterDialogBar roViewportLayout style:#(#cui_dock_top, #cui_dock_bottom, #cui_floatable)



viewport.GetRenderLevel()
viewport.SetRenderLevel ("smoothhighlights" as name)
