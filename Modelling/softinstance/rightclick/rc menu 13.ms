-- variables
	global NewRCmenu=""
	global sep=0
	global menuStr = "\n " as stringstream
	global handlerStr = "\n " as stringstream
	global srcObj, trgObj
	global srcArr=#()
	global trgArr=#()
	global arr=srcArr


/*

-- set up structures to hold data
 	struct copyProps (obj,prop,value)
	newCopyProps = copyProps srcObj:undefined trgObj:undefined menu1:undefined menu2:undefined
*/

	
--=====================================================================================
-- Utility funstions
--=====================================================================================

fn fileToString file=
	(
	str=stringstream ""
	strFile = openFile file
	while not eof strFile do
		(
		format "%\n" (readline strFile) to:str
		)
	return str as string
	)

fn flt_objects = (srcObj != undefined) -- objects filter 

fn flt_isNotMultiMat =
	(
	if srcObj.material != undefined then
		srcObj.material != Multimaterial
	else false
	)

fn flt_isNotSameObj obj = obj!=SrcObj


--=====================================================================================
-- Help/Options stuff functions
--=====================================================================================






fn helpBox =
	(
	rollout roHelp "Help" width:312 height:312
		(
		groupBox grp1 "Overview" pos:[8,8] width:296 height:136
		label lbl1 "This script is designed to quickly and easily copy properties from one object to another." pos:[16,24] width:280 height:112
		---------------------------------------------------------------------------------------------------
		-- declarations
		---------------------------------------------------------------------------------------------------
	
	
	
		---------------------------------------------------------------------------------------------------
		-- Interface
		---------------------------------------------------------------------------------------------------
	
	
	
		---------------------------------------------------------------------------------------------------
		-- Functions
		---------------------------------------------------------------------------------------------------
	
	
	
		---------------------------------------------------------------------------------------------------
		-- Handlers
		---------------------------------------------------------------------------------------------------
	
	
		)	
	if pmHelpFloater != undefined then closerolloutfloater pmHelpFloater
		pmHelpFloater = newRolloutFloater "Property Matcher Help" 325 500 
	addRollout roHelp pmHelpFloater
	)

fn optionsBox =
	(
	rollout roOpts "Options" width:168 height:312
		(
		GroupBox grp1 "Options" pos:[8,8] width:152 height:208
		radioButtons rdo1 "Copy..." pos:[16,24] width:111 height:46 labels:#("Value Only", "Instance Controller")
		checkbox chk1 "Auto-assign controllers" pos:[16,80] width:136 height:16
		---------------------------------------------------------------------------------------------------
		-- declarations
		---------------------------------------------------------------------------------------------------
	
	
	
		---------------------------------------------------------------------------------------------------
		-- Interface
		---------------------------------------------------------------------------------------------------
	
	
	
		---------------------------------------------------------------------------------------------------
		-- Functions
		---------------------------------------------------------------------------------------------------
	
	
	
		---------------------------------------------------------------------------------------------------
		-- Handlers
		---------------------------------------------------------------------------------------------------
	
	
		)
	if pmOptFloater != undefined then closerolloutfloater pmOptFloater
		pmOptFloater = newRolloutFloater "Property Matcher Options" 188 200 
	addRollout roOpts pmOptFloater
	)

--=====================================================================================
-- Sub Menu functions
--=====================================================================================


fn doTrans p r s par=
	(
	pushPrompt "Select target object..."
	trgObj = pickObject filter:flt_isNotSameObj rubberBand:srcObj.pos

	if p==1 then srcObj.pos=trgObj.pos
	if r==1 then
		(
		-- rotate without messing with position
		in coordsys (transmatrix srcObj.transform.pos) 
	    srcObj.rotation = trgObj.rotation as EulerAngles
		)
	if s==1 then srcObj.scale=trgObj.scale
	if par==1 then srcObj.parent=trgObj

	popPrompt()
	)


fn doStack obj prop1 prop2=
	(

	messageBox (obj as string +" | "+ prop1 as string +" | "+ prop2 as string)

	pushPrompt "Select target object..."
	--trgObj = pickObject filter:flt_isNotSameObj rubberBand:srcObj.pos

	popPrompt()
	)

fn doMat obj prop =
	(
	)

--=====================================================================================
-- Main Menu functions
--=====================================================================================


fn buildStackLevelMenu obj level=
	(
	local mStr=""
	if superclassof obj == modifier then mStr= obj.name as string
	else mStr = obj as string
	
	format "	subMenu \"%\"\n		(\n" mStr to:menuStr
	-- All
		local mEnable= (getPropNames obj).count>0
		-- menu items
			format "		menuItem mi_Stack%_All \"All\" enabled:% \n" level mEnable to:menuStr
			format "		menuItem mi_Stack%_AllExcept \"All Except...\" enabled:% \n" level mEnable to:menuStr
			format "		separator sep%\n" (sep+=1) to:menuStr
			
		-- handlers
			format "	on mi_Stack%_ALL picked do doStack % #all #null\n" level level to:handlerStr
			format "	on mi_Stack%_ALLExcept picked do doStack % #allExcept #null\n" level level to:handlerStr


	-- Individual properties of modifier/baseObject
		local propArr=getPropNames obj
		for m = 1 to propArr.count do
			(
		-- straight properties
			if classof (getProperty obj propArr[m]) != SubAnim then
				(
			-- menu items
				format "		menuItem mi_Stack%_% \"%\"\n" level m (propArr[m] as string) to:menuStr
			-- handlers
				format "	on mi_Stack%_% picked do doStack % % #null\n" level m level propArr[m] to:handlerStr
				)
		-- subanims
			else
				(
				format "		subMenu \"%...\"\n			(\n" (propArr[m] as string) to:menuStr
				-- All

					-- menu items
						format "		menuItem mi_Stack%_%_%_All \"All\"\n" level m (p as string) to:menuStr
						format "		separator sep%\n" (sep+=1) to:menuStr
						
					-- handlers
						format "	on mi_Stack%_%_%_ALL picked do doStack % % #all\n" level m (p as string) level propArr[m] to:handlerStr
			
				
				-- individual properties
					for p in (getSubAnimNames obj[propArr[m]]) do
						(
					-- menu items
						format "			menuItem mi_Stack%_%_% \"%\"\n" level m (p as string) (p as string) to:menuStr
						--format "menuItem cunt \"cunt\"\n" to:menuStr
					-- handlers
						format "		on mi_Stack%_%_% picked do doStack % % %\n" level m (p as string) level propArr[m] p to:handlerStr
/*
*/
						)
					format "\n			)\n" to:menuStr
				)
			
			)

	format "\n		)\n" to:menuStr
	)




fn buildTransMenu obj =
	(
	------------------------------------------------------------
	-- Transforms
	------------------------------------------------------------
		-- menu
			format "subMenu \"Transform...\"\n	(\n" to:menuStr
			-- ...and Parent
				format "subMenu \"...and Parent...\"\n	(\n" to:menuStr
					format "	menuItem mi_TransParPRS \"All\"\n" mStr to:menuStr
					format "	separator sep%\n" (sep+=1) to:menuStr
					format "	menuItem mi_TransParPR \"Pos, Rot\"\n" mStr to:menuStr
					format "	separator sep%\n" (sep+=1) to:menuStr
					format "	menuItem mi_TransParP \"Position\"\n" mStr to:menuStr
					format "	menuItem mi_TransParR \"Rotation\"\n" mStr to:menuStr
					format "	menuItem mi_TransParS \"Scale\"\n" mStr to:menuStr
	
				format "\n	)\n" to:menuStr
	
			-- Transforms
				format "	separator sep%\n" (sep+=1) to:menuStr
	
				format "	menuItem mi_TransPRS \"All\"\n" mStr to:menuStr
				format "	separator sep%\n" (sep+=1) to:menuStr
				format "	menuItem mi_TransPR \"Pos, Rot\"\n" mStr to:menuStr
				format "	separator sep%\n" (sep+=1) to:menuStr
				format "	menuItem mi_TransP \"Position\"\n" mStr to:menuStr
				format "	menuItem mi_TransR \"Rotation\"\n" mStr to:menuStr
				format "	menuItem mi_TransS \"Scale\"\n" mStr to:menuStr
			format "\n	)\n" to:menuStr
	

		-- handlers
			local transHandlers = fileToString "transHandlers.ms"
			format "%\n" transHandlers to:menuStr
/*
*/
	)


fn buildMatMenu obj =
	(
	------------------------------------------------------------
	-- Material
	------------------------------------------------------------

	if obj.material!=undefined then
		(
		format "subMenu \"Groups...\"\n	(\n" to:menuStr
	
			format "	menuItem mi_MatGroupAll \"All\"" to:menuStr
			format "	menuItem mi_MatGroupAllExcept \"All Except...\"" to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			local matArr =#("Ambient","Diffuse","Specular / Glossiness","Shader","Opacity","Bump","Self Illumination","Reflection")
			for n = 1 to matArr.count do
				(
				format "	menuItem mi_Mat% \"%\"\n" n matArr[n] to:menuStr
				)
		format "\n	)\n" to:menuStr

		format "subMenu \"Individual...\"\n	(\n" to:menuStr
	
		-- Individual properties
			local propArr=sort(getPropNames obj.material)
			format "	menuItem mi_MatIndAll \"All\"" to:menuStr
			format "	menuItem mi_MatIndAllExcept \"All Except...\"" to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			for m = 1 to propArr.count do
				(
				-- menu items
					format "		menuItem mi_MatInd% \"%\"\n" m (propArr[m] as string) to:menuStr
	
				-- handlers
					--format "	on mi_mi_MatInd% picked do doMat % %\n" m level propArr[m] to:handlerStr
				)

		format "\n	)\n" to:menuStr
		)
	)


--=====================================================================================
-- Main code
--=====================================================================================



fn buildMainMenu obj =
	(
	-- reset all vars
		sep=0
		--menuStr = stringstream "\n "
	
	format "rcmenu myRCMenu (\n" to:menuStr

		(
	
			format "menuItem mi_Title \"Select property to replace...\" enabled:false\n" to:menuStr
			format "separator sep%\n" (sep+=1) to:menuStr
	
	
		------------------------------------------------------------
		-- Build Menus
		------------------------------------------------------------
		-- stack
			-- reset handlerStr
				handlerStr = stringstream ""
			-- menus
				format "subMenu \"Stack values...\"\n	(\n" to:menuStr
					-- mods
						for n = 1 to obj.modifiers.count do
							(
							buildStackLevelMenu obj.modifiers[n] n
							)
						format "	separator sep%\n" (sep+=1) to:menuStr
					-- base object
						buildStackLevelMenu obj.baseObject 0
				format "\n	)\n" to:menuStr
				
			-- insert handler menu string
				format "%\n" (handlerStr as string) to:menuStr

		-- transform

			buildTransMenu obj

			
			
		-- material
			if NOT flt_isNotMultiMat() then 
			format "	menuItem mi_Mat \"Material...\" enabled:false\n" to:menuStr
	
			format "subMenu \"Material...\" filter:flt_isNotMultiMat\n	(\n" to:menuStr
				buildMatMenu obj
			format "\n	)\n" to:menuStr
/*
*/

		------------------------------------------------------------
		-- Help and options
		------------------------------------------------------------
	
		-- menu
			format "separator sep%\n" (sep+=1) to:menuStr
			format "menuItem mi_options \"Options...\"\n" to:menuStr
	
		-- Handlers
			format "on mi_Options picked do optionsBox()\n" to:menuStr


		-- menu
			format "separator sep%\n" (sep+=1) to:menuStr
			format "menuItem mi_Help \"Help...\"\n" to:menuStr
	
		-- Handlers
			format "on mi_Help picked do helpBox()\n" to:menuStr


	
		)
	format "\n)" to:menuStr


	close menuStr
	execute(menuStr as string)
	)


--=====================================================================================
-- Go!
--=====================================================================================


-- set data
	srcObj=$
	if srcObj == undefined then srcObj=pickObject()
	buildMainMenu srcObj
	registerRightClickMenu myRCMenu


	popUpMenu myRCMenu
/*	
	
	pushPrompt "Select target object..."
	trgObj = pickObject filter:flt_isNotSameObj rubberBand:srcObj.pos
	
	newMenuName= "cpMenu2"
	newMenu = buildMainMenu newMenuName trgObj "trans"
	registerRightClickMenu newMenu
	popUpMenu newMenu
	popPrompt()
*/
--menuStr