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
-- Sub Menu functions
--=====================================================================================


fn doTrans p r s par=
	(
	pushPrompt "Select target object..."
	trgObj = pickObject filter:flt_isNotSameObj rubberBand:srcObj.pos

	if p==1 then srcObj.pos=trgObj.pos
	if r==1 then
		(
		in coordsys (transmatrix srcObj.transform.pos) 
	    srcObj.rotation = trgObj.rotation as EulerAngles
		)
	if s==1 then srcObj.scale=trgObj.scale
	if par==1 then srcObj.parent=trgObj

	popPrompt()
	)


fn doStack srcNode srcProp=
	(

	messageBox (srcNode +" | "+ srcProp)



	pushPrompt "Select target object..."
	trgObj = pickObject filter:flt_isNotSameObj rubberBand:srcObj.pos

	popPrompt()
	)

--=====================================================================================
-- Main Menu functions
--=====================================================================================


fn buildStackLevelMenu obj level=
	(
	local mStr
	if obj != srcObj.baseObject then mStr=obj.modifiers[n].name as string
	else mStr = obj as string
	
	format "	subMenu \"%\"\n		(\n" mStr to:menuStr
	/*
		local mEnable= (getPropNames obj).count>0
		format "		menuItem mi_Stack%_All \"All\" enabled:% \n" level mEnable to:menuStr
		format "		separator sep%\n" (sep+=1) to:menuStr

	-- Individual properties
		local propArr=getPropNames obj
		for m = 1 to propArr.count do
			format "		menuItem mi_Stack%_% \"%\"\n" level m (propArr[m] as string) to:menuStr

	*/
	format "\n	)\n" to:menuStr
	)
/*
fn buildStackMenu obj =
	(
	------------------------------------------------------------
	-- Stack values
	------------------------------------------------------------


		-- Modifiers
			for n = obj.modifiers.count to 1 by -1 do
				(
				local mStr=obj.modifiers[n].name as string
				format "	subMenu \"%\"\n		(\n" mStr to:menuStr
					local mEnable= (getPropNames obj.modifiers[n]).count>0
					format "		menuItem mi_Stack%_All \"All\" enabled:% \n" n mEnable to:menuStr
					format "		separator sep%\n" (sep+=1) to:menuStr

				-- Individual properties
					local propArr=getPropNames obj.modifiers[n]
					for m = 1 to propArr.count do
						format "		menuItem mi_Stack%_% \"%\"\n" n m (propArr[m] as string) to:menuStr

				format "\n	)\n" to:menuStr
				)


		-- Base Object
			format "	separator sep%\n" (sep+=1) to:menuStr
			local mStr= obj.baseObject as string

			format "	subMenu \"%\"\n	(\n" mStr to:menuStr

				format "		menuItem mi_StackAll \"All\"\n" to:menuStr
				format "		separator sep%\n" (sep+=1) to:menuStr

				-- Individual properties
					local propArr=getPropNames obj.baseObject
					for m = 1 to propArr.count do
						format "		menuItem mi_Stack0_% \"%\"\n" m (propArr[m] as string) to:menuStr
			format "\n	)\n" to:menuStr

	
	)

*/
fn buildTransMenu obj =
	(
	------------------------------------------------------------
	-- Transforms
	------------------------------------------------------------
		-- menu
			format "subMenu \"Transform...\"\n	(\n" to:menuStr
			-- ...and Parent
				format "subMenu \"Transform and Parent\"\n	(\n" to:menuStr
					format "	menuItem mi_TransParPRS \"ALL\"\n" mStr to:menuStr
					format "	separator sep%\n" (sep+=1) to:menuStr
					format "	menuItem mi_TransParPR \"Pos, Rot\"\n" mStr to:menuStr
					format "	separator sep%\n" (sep+=1) to:menuStr
					format "	menuItem mi_TransParP \"Position\"\n" mStr to:menuStr
					format "	menuItem mi_TransParR \"Rotation\"\n" mStr to:menuStr
					format "	menuItem mi_TransParS \"Scale\"\n" mStr to:menuStr
	
				format "\n	)\n" to:menuStr
	
			-- Transforms
				format "	separator sep%\n" (sep+=1) to:menuStr
	
				format "	menuItem mi_TransPRS \"ALL\"\n" mStr to:menuStr
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
	)


fn buildMatMenu obj =
	(
	------------------------------------------------------------
	-- Material
	------------------------------------------------------------

		format "	menuItem mi_MatAll \"All\"" to:menuStr
		format "	separator sep%\n" (sep+=1) to:menuStr
		local matArr =#("Ambient","Diffuse","Specular / Glossiness","Shader","Opacity","Bump","Self Illumination","Reflection")
		for n = 1 to matArr.count do
			(
			format "	menuItem mi_Mat% \"%\"\n" n matArr[n] to:menuStr
			)
	)


--=====================================================================================
-- Main code
--=====================================================================================

global sep
global menuStr
global NewRCmenu


fn buildMainMenu menuName obj mode=
	(
	-- reset all vars
		sep=0
		menuStr= stringStream ""
	
	format "rcmenu %(\n" menuName to:menuStr

	if mode=="" then
		(
	
			format "menuItem mi_Title \"Select property to replace...\" enabled:false\n" to:menuStr
			format "separator sep%\n" (sep+=1) to:menuStr
	
	
		------------------------------------------------------------
		-- Build Menus
		------------------------------------------------------------
		-- stack
			-- menus
				format "subMenu \"Stack values...\"\n	(\n" to:menuStr
					--buildStackMenu obj
					-- mods
						for n = 1 to obj.modifiers.count do
							(
							buildStackLevelMenu obj.modifiers[n] n
							)
						format "		separator sep%\n" (sep+=1) to:menuStr
					-- base object
						buildStackLevelMenu obj.baseObject 0
				format "\n	)\n" to:menuStr

			-- handlers
				--buildStackHandlers obj
			


		-- transformation
			buildTransMenu obj

			
			
		-- material
			if NOT flt_isNotMultiMat() then 
			format "	menuItem mi_Mat \"Material...\" enabled:false\n" to:menuStr
	
			format "subMenu \"Material...\" filter:flt_isNotMultiMat\n	(\n" to:menuStr
				buildMatMenu obj
			format "\n	)\n" to:menuStr
	
	
		------------------------------------------------------------
		-- Help and options
		------------------------------------------------------------
	
		-- menu
			format "separator sep%\n" (sep+=1) to:menuStr
			format "menuItem mi_options \"Options...\"\n" to:menuStr
	
		-- Handlers
			format "on mi_Options picked do messageBox \"Options!\"\n" to:menuStr


		-- menu
			format "separator sep%\n" (sep+=1) to:menuStr
			format "menuItem mi_Help \"Help...\"\n" to:menuStr
	
		-- Handlers
			format "on mi_Help picked do messageBox \"Help!\"\n" to:menuStr


	
		)
	else
		(
		------------------------------------------------------------
		-- Build Menus
		------------------------------------------------------------
	
			if mode=="stack" then buildStackMenu obj
			if mode=="trans" then buildTransMenu obj
			if mode=="mat" then buildMatMenu obj
	
		)
	format "\n)" to:menuStr


	close menuStr
	execute(menuStr as string)
	)


--=====================================================================================
-- Go!
--=====================================================================================

-- set up structures to hold data
	struct copyProps (srcObj,trgObj,menu1,menu2)
	newCopyProps = copyProps srcObj:undefined trgObj:undefined menu1:undefined menu2:undefined

-- set data
	srcObj=$
	if srcObj == undefined then srcObj=pickObject()
	
	newMenuName= "cpMenu1"
	newMenu = buildMainMenu newMenuName srcObj ""
	registerRightClickMenu newMenu
	popUpMenu newMenu
	
/*	
	pushPrompt "Select target object..."
	trgObj = pickObject filter:flt_isNotSameObj rubberBand:srcObj.pos
	
	newMenuName= "cpMenu2"
	newMenu = buildMainMenu newMenuName trgObj "trans"
	registerRightClickMenu newMenu
	popUpMenu newMenu
	popPrompt()
*/