fn doTrans p r s par=
(
	trgObj = pickObject()
	switch case
	
)

fn flt_objects = (srcObj != undefined) -- objects filter 

fn flt_isNotMultiMat =
(
	if srcObj.material != undefined then
		srcObj.material != Multimaterial
	else false
)

fn fileToString file =
(
	local str=stringstream ""
	local strFile = openFile file
	while not eof strFile do
	(
		format "%\n" (readline strFile) to:str
	)
	return (str as string)
)

srcObj =pickObject()

sep=0

	menuStr=""
	menuStr= stringStream ""

	format "rcmenu NewRCmenu(\n" to:menuStr

		format "menuItem mi_Title \"Select property to replace...\" enabled:false\n" to:menuStr
		format "separator sep%\n" (sep+=1) to:menuStr



	------------------------------------------------------------
	-- Stack values
	------------------------------------------------------------

		format "subMenu \"Stack values...\"\n	(\n" to:menuStr

			-- Modifiers
				for n = srcObj.modifiers.count to 1 by -1 do
				(
					mStr=srcObj.modifiers[n].name as string
					format "	subMenu \"%\"\n		(\n" mStr to:menuStr
						mEnable= (getPropNames srcObj.modifiers[n]).count>0
						format "		menuItem mi_Stack%_All \"All\" enabled:% \n" n mEnable to:menuStr
						format "		separator sep%\n" (sep+=1) to:menuStr

					-- Individual properties
						propArr=getPropNames srcObj.modifiers[n]
						for m = 1 to propArr.count do
							format "		menuItem mi_Stack%_% \"%\"\n" n m (propArr[m] as string) to:menuStr

					format "\n	)\n" to:menuStr
				)
	
	
			-- Base Object
				format "	separator sep%\n" (sep+=1) to:menuStr
				mStr= srcObj.baseObject as string

				format "	subMenu \"%\"\n	(\n" mStr to:menuStr

					format "		menuItem mi_StackAll \"All\"\n" to:menuStr
					format "		separator sep%\n" (sep+=1) to:menuStr
	
					-- Individual properties
						propArr=getPropNames srcObj.baseObject
						for m = 1 to propArr.count do
							format "		menuItem mi_Stack0_% \"%\"\n" m (propArr[m] as string) to:menuStr
				format "\n	)\n" to:menuStr
	

		format "\n	)\n" to:menuStr


	------------------------------------------------------------
	-- Transforms
	------------------------------------------------------------
	-- menu
		format "subMenu \"Transform...\"\n	(\n" to:menuStr

			-- ...and Parent
				format "subMenu \"...and Parent\"\n	(\n" to:menuStr
					format "	menuItem mi_TransParPRS \"ALL\"\n" mStr to:menuStr
					format "	separator sep%\n" (sep+=1) to:menuStr
					format "	menuItem mi_TransParPR \"Pos, Rot\"\n" mStr to:menuStr
					format "	separator sep%\n" (sep+=1) to:menuStr
					format "	menuItem mi_TransParP \"Position\"\n" mStr to:menuStr
					format "	menuItem mi_TransParR \"Rotation\"\n" mStr to:menuStr
					format "	menuItem mi_TransParS \"Scale\"\n" mStr to:menuStr

				format "\n	)\n" to:menuStr
	
			-- Transforms
				format "separator sep%\n" (sep+=1) to:menuStr
	
				format "	menuItem mi_TransPRS \"ALL\"\n" mStr to:menuStr
				format "	separator sep%\n" (sep+=1) to:menuStr
				format "	menuItem mi_TransPR \"Pos, Rot\"\n" mStr to:menuStr
				format "	separator sep%\n" (sep+=1) to:menuStr
				format "	menuItem mi_TransP \"Position\"\n" mStr to:menuStr
				format "	menuItem mi_TransR \"Rotation\"\n" mStr to:menuStr
				format "	menuItem mi_TransS \"Scale\"\n" mStr to:menuStr
	
		format "\n	)\n" to:menuStr


	-- handlers
		transHandlers = fileToString "transHandlers.ms"
--		format "	%\n" transHandlers to:menuStr
		
	------------------------------------------------------------
	-- Material
	------------------------------------------------------------

		if NOT flt_isNotMultiMat() then 
		format "	menuItem mi_Mat \"Material...\" enabled:false\n" to:menuStr

		format "subMenu \"Material...\" filter:flt_isNotMultiMat\n	(\n" to:menuStr
			format "	menuItem mi_MatAll \"All\"" to:menuStr
			format "	separator sep%\n" (sep+=1) to:menuStr
			matArr =#("Ambient","Diffuse","Specular / Glossiness","Shader","Opacity","Bump","Self Illumination","Reflection")
			for n = 1 to matArr.count do
			(
				format "	menuItem mi_Mat% \"%\"\n" n matArr[n] to:menuStr
			)

		format "\n	)\n" to:menuStr


	------------------------------------------------------------
	-- Help
	------------------------------------------------------------

	format "	separator sep%\n" (sep+=1) to:menuStr
	format "menuItem mi_Help \"Help...\"\n" to:menuStr



	--==========================================================
	-- Handlers

	format "on mi_Help picked do messageBox \"Help!\"\n" to:menuStr

	format "\n)" to:menuStr


close menuStr
--menuStr

unRegisterRightClickMenu NewRCmenu
execute(menuStr as string)
registerRightClickMenu NewRCmenu
popUpMenu NewRCmenu
