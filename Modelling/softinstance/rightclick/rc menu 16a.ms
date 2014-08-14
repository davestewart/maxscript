--=====================================================================================
-- Global Declarations
--=====================================================================================
	global cpRCMenu=""
	global cpSep=0
	global cpMenuStr = "" as stringstream
	global cpHandlerStr = "" as stringstream
	global cpCopyType=2
	global cpMode=""

 	struct cpData (obj,mLevel,mProp,saProp)

	global cpSrcProps = cpData	\
		obj:undefined	\
		mLevel:undefined	\
		mProp:undefined	\
		saProp:undefined
	global cpTrgProps =	cpData	\
		obj:undefined	\
		mLevel:undefined	\
		mProp:undefined	\
		saProp:undefined

	
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

fn flt_objects obj = (obj != undefined) -- objects filter 

fn flt_isNotMultiMat obj =
	(
	if obj.material != undefined then
		obj.material != Multimaterial
	else false
	)



--=====================================================================================
-- Help/Options stuff functions
--=====================================================================================


fn helpBox =
	(
	rollout roHelp "Help" width:312 height:312
		(
		groupBox grp1 "Overview" pos:[8,8] width:296 height:136
		label lbl1 "This script is designed to quickly and easily copy properties from one object to another using the familiar right-click menu tree structure.
You can copy any property to any other property as just the value, a copy of the controller, or an instance of controller.
If the values are incompatible, nothing will happen.
" pos:[16,24] width:280 height:112

		groupBox grp2 "Usage" pos:[8,148] width:296 height:136
		label lbl2 " - Quickly match disparate properties such as UVW width and Plane width
Copy common properties accross different objects, such as SuperSpary/PCloud or Cylinder/Cones
Create a 'soft instance' by copying all properties from one object to another, except the ones you want to be different
Easily instance rotation paramaters from a transform to a Gizmo's Transform
" pos:[16,164] width:280 height:112

		-- declarations

		-- Interface
	
		-- Functions

		-- Handlers
	
	
		)	
	if pmHelpFloater != undefined then closerolloutfloater pmHelpFloater
		pmHelpFloater = newRolloutFloater "Property Matcher Help" 325 500
	addRollout roHelp pmHelpFloater
	)

fn optionsBox =
	(
	rollout roOpts "Options" width:168 height:312
		(
		radiobuttons rdo1 "Copy property..." pos:[8,8] width:110 height:62 labels:#("Copy value only", "Copy controller", "Instance controller")
		radiobuttons rdo2 "Copy method..." pos:[8,80] width:57 height:46 labels:#("By modifier index","By modifier name") columns:1
--		checkbox chk1 "Auto-assign controllers" pos:[16,80] width:136 height:16

		-- declarations

		-- Interface
	
		-- Functions

		-- Handlers
	
	
		)
	if pmOptFloater != undefined then closerolloutfloater pmOptFloater
		pmOptFloater = newRolloutFloater "Property Matcher Options" 188 200 
	addRollout roOpts pmOptFloater
	)



--=====================================================================================
-- Sub Menu handler code
--=====================================================================================



fn doStack level mProp saProp=
	(
	--messageBox (obj as string +" | "+ prop1 as string +" | "+ prop2 as string)

	-- work out the node from the data...
		format "level: %\n" level
		format "mProp: %\n" mProp
		format "saProp: %\n" saProp
/*
		local srcNode
		local srcNodePropValue
		local srcNodePropController





		if level>0 then
			(
			srcNode=				srcObj.modifiers[level]
			srcNodePropValue=		execute("$"+srcObj.name+".modifiers["+level as string+"]."+mProp as string)
			srcNodePropController=	execute("$"+srcObj.name+".modifiers["+level as string+"]."+mProp as string+".controller")

			--srcProp=srcNode[mProp]
			)
		else
			srcNode=srcObj.baseObject[mProp as name]

		format ">% % %\n" srcNode srcNodePropValue srcNodePropValue.controller --srcNodePropController
*/

	if cpMode=="src" then
		(
		cpSrcProps.mLevel=level
		cpSrcProps.mProp=mProp
		cpSrcProps.saProp=saProp
		)
	else if cpMode=="trg" then
		(
		cpTrgProps.mLevel=level
		cpTrgProps.mProp=mProp
		cpTrgProps.saProp=saProp
		)
	)


fn doTrans p r s par=
	(
	trgObj = pickObject filter:flt_isNotSameObj rubberBand:srcObj.pos

	-- position
		if p==1 then srcObj.pos=trgObj.pos

	-- rotation
		if r==1 then
			(
			-- rotate without messing with position
			in coordsys (transmatrix srcObj.transform.pos) 
		    srcObj.rotation = trgObj.rotation as EulerAngles
			)
	-- scale
		if s==1 then srcObj.scale=trgObj.scale

	-- parent
		if par==1 then srcObj.parent=trgObj

	)


fn doMat obj prop =
	(
	)

--=====================================================================================
-- Sub Menu functions
--=====================================================================================


fn buildStackLevelMenu obj level=
	(
	local mStr=""
	if superclassof obj == modifier then mStr= obj.name as string
	else mStr = obj as string
	
	format "	subMenu \"%\"\n		(\n" mStr to:cpMenuStr
	-- All
		local mEnable= (getPropNames obj).count>0
		-- menu items
			format "		menuItem mi_Stack%_All \"All\" enabled:% \n" level mEnable to:cpMenuStr
			format "		menuItem mi_Stack%_AllExcept \"All Except...\" enabled:% \n" level mEnable to:cpMenuStr
			format "		separator sep%\n" (cpSep+=1) to:cpMenuStr
			
		-- handlers
			format "	on mi_Stack%_ALL picked do doStack % #all #null\n" level level to:cpHandlerStr
			format "	on mi_Stack%_ALLExcept picked do doStack % #allExcept #null\n" level level to:cpHandlerStr


	-- Individual properties of modifier/baseObject
		local propArr=getPropNames obj
		for m = 1 to propArr.count do
			(
		-- straight properties
			if classof (getProperty obj propArr[m]) != SubAnim then
				(
			-- menu items
				format "		menuItem mi_Stack%_% \"%\"\n" level m (propArr[m] as string) to:cpMenuStr
			-- handlers
				format "	on mi_Stack%_% picked do doStack % % #null\n" level m level propArr[m] to:cpHandlerStr
				)
		-- subanims
			else
				(
				format "		subMenu \"%...\"\n			(\n" (propArr[m] as string) to:cpMenuStr
				-- All

					-- menu items
						format "		menuItem mi_Stack%_%_%_All \"All\"\n" level m (p as string) to:cpMenuStr
						format "		separator sep%\n" (cpSep+=1) to:cpMenuStr
						
					-- handlers
						format "	on mi_Stack%_%_%_ALL picked do doStack % % #all\n" level m (p as string) level propArr[m] to:cpHandlerStr
			
				
				-- individual properties
					for p in (getSubAnimNames obj[propArr[m]]) do
						(
					-- menu items
						format "			menuItem mi_Stack%_%_% \"%\"\n" level m (p as string) (p as string) to:cpMenuStr
						--format "menuItem cunt \"cunt\"\n" to:cpMenuStr
					-- handlers
						format "		on mi_Stack%_%_% picked do doStack % % %\n" level m (p as string) level propArr[m] p to:cpHandlerStr
/*
*/
						)
					format "\n			)\n" to:cpMenuStr
				)
			
			)

	format "\n		)\n" to:cpMenuStr
	)




fn buildTransMenu obj =
	(
	------------------------------------------------------------
	-- Transforms
	------------------------------------------------------------
		-- menu
			format "subMenu \"Transform...\"\n	(\n" to:cpMenuStr
			-- ...and Parent
				format "subMenu \"...and Parent...\"\n	(\n" to:cpMenuStr
					format "	menuItem mi_TransParPRS \"All\"\n" mStr to:cpMenuStr
					format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
					format "	menuItem mi_TransParPR \"Pos, Rot\"\n" mStr to:cpMenuStr
					format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
					format "	menuItem mi_TransParP \"Position\"\n" mStr to:cpMenuStr
					format "	menuItem mi_TransParR \"Rotation\"\n" mStr to:cpMenuStr
					format "	menuItem mi_TransParS \"Scale\"\n" mStr to:cpMenuStr
	
				format "\n	)\n" to:cpMenuStr
	
			-- Transforms
				format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
	
				format "	menuItem mi_TransPRS \"All\"\n" mStr to:cpMenuStr
				format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
				format "	menuItem mi_TransPR \"Pos, Rot\"\n" mStr to:cpMenuStr
				format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
				format "	menuItem mi_TransP \"Position\"\n" mStr to:cpMenuStr
				format "	menuItem mi_TransR \"Rotation\"\n" mStr to:cpMenuStr
				format "	menuItem mi_TransS \"Scale\"\n" mStr to:cpMenuStr
			format "\n	)\n" to:cpMenuStr
	

		-- handlers
			local transHandlers = fileToString "transHandlers.ms"
			format "%\n" transHandlers to:cpMenuStr
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
		format "subMenu \"Groups...\"\n	(\n" to:cpMenuStr
	
			format "	menuItem mi_MatGroupAll \"All\"" to:cpMenuStr
			format "	menuItem mi_MatGroupAllExcept \"All Except...\"" to:cpMenuStr
			format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
			local matArr =#("Ambient","Diffuse","Specular / Glossiness","Shader","Opacity","Bump","Self Illumination","Reflection")
			for n = 1 to matArr.count do
				(
				format "	menuItem mi_Mat% \"%\"\n" n matArr[n] to:cpMenuStr
				)
		format "\n	)\n" to:cpMenuStr

		format "subMenu \"Individual...\"\n	(\n" to:cpMenuStr
	
		-- Individual properties
			local propArr=sort(getPropNames obj.material)
			format "	menuItem mi_MatIndAll \"All\"" to:cpMenuStr
			format "	menuItem mi_MatIndAllExcept \"All Except...\"" to:cpMenuStr
			format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
			for m = 1 to propArr.count do
				(
				-- menu items
					format "		menuItem mi_MatInd% \"%\"\n" m (propArr[m] as string) to:cpMenuStr
	
				-- handlers
					--format "	on mi_mi_MatInd% picked do doMat % %\n" m level propArr[m] to:cpHandlerStr
				)

		format "\n	)\n" to:cpMenuStr
		)
	)


--=====================================================================================
-- Main Menu
--=====================================================================================
fn buildMainMenu obj =
	(
	-- reset all vars
		sep=0
		cpMenuStr= "" as stringstream
	
	-- set up title
		local titleStr
		local cpCopyTypeStr=""

		if cpCopyType==0 then cpCopyTypeStr="value only"
		else if cpCopyType==1 then cpCopyTypeStr="copy controller"
		else if cpCopyType==2 then cpCopyTypeStr="instance controller"
		
		if cpMode=="src" then titleStr="REPLACE ("+cpCopyTypeStr+") ..."
		else titleStr="WITH ("+cpCopyTypeStr+") ..."


	-- start menu strucure

	format "rcmenu cpRCMenu (\n" to:cpMenuStr
		(
			format "menuItem mi_Title \"%\" enabled:false\n" titleStr to:cpMenuStr
			format "separator sep%\n" (cpSep+=1) to:cpMenuStr
	
	
		------------------------------------------------------------
		-- Build Menus
		------------------------------------------------------------
		-- stack
			-- reset cpHandlerStr
				cpHandlerStr = stringstream ""
			-- menus
				format "subMenu \"Stack values...\"\n	(\n" to:cpMenuStr
					-- mods
						for n = 1 to obj.modifiers.count do
							(
							buildStackLevelMenu obj.modifiers[n] n
							)
						format "	separator sep%\n" (cpSep+=1) to:cpMenuStr
					-- base object
						buildStackLevelMenu obj.baseObject 0
				format "\n	)\n" to:cpMenuStr
				
			-- insert handler menu string
				format "%\n" (cpHandlerStr as string) to:cpMenuStr

		-- transform

			buildTransMenu obj

			
			
		-- material
		/*
			if NOT flt_isNotMultiMat obj then
				(
			
				format "	menuItem mi_Mat \"Material...\" enabled:false\n" to:cpMenuStr
		
				format "subMenu \"Material...\" filter:flt_isNotMultiMat %\n	(\n" obj to:cpMenuStr
					buildMatMenu obj
				format "\n	)\n" to:cpMenuStr
				)
		*/

		------------------------------------------------------------
		-- Help and options
		------------------------------------------------------------
	
		-- menu
			format "separator sep%\n" (cpSep+=1) to:cpMenuStr
			format "menuItem mi_options \"Options...\"\n" to:cpMenuStr
	
		-- Handlers
			format "on mi_Options picked do optionsBox()\n" to:cpMenuStr


		-- menu
			format "separator sep%\n" (cpSep+=1) to:cpMenuStr
			format "menuItem mi_Help \"Help...\"\n" to:cpMenuStr
	
		-- Handlers
			format "on mi_Help picked do helpBox()\n" to:cpMenuStr


	
		)
	format "\n)" to:cpMenuStr


	close cpMenuStr
	execute(cpMenuStr as string)
	)


--=====================================================================================
-- Main function
--=====================================================================================


fn copyTypeDialogue =
	(
	rollout roOpts "Options" width:128 height:88
		(
		button BtnCancel "Cancel" pos:[8,64] width:112 height:16
		radiobuttons rdo1 "" pos:[8,8] width:111 height:48 labels:#("Copy values only", "Copy controller", "Instance Controller") default:0
		on BtnCancel pressed do	DestroyDialog roOpts
		on rdo1 changed state do
			(
			cpCopyType = case state of
				(
				1:	1
				2:	2
				3:	3
				)
				DestroyDialog roOpts
			)
		)
	CreateDialog roOpts modal:true pos:(mouse.screenpos-[18,34])
	)
fn copyProps =
	(

	copyTypeDialogue()
	--disableSceneRedraw() 

-- get stack level
	local srcProp
	case of 
		( 
		(cpSrcProps.mLevel == 0):	srcProp = cpSrcProps.obj.baseObject
		(cpSrcProps.mLevel > 0):	srcProp = cpSrcProps.obj.modifiers[cpSrcProps.mLevel]
		default: messageBox "Couldn't get stack level"
		) 

	local trgProp
	case of 
		( 
		(cpTrgProps.mLevel == 0):	trgProp = cpTrgProps.obj.baseObject
		(cpTrgProps.mLevel > 0):	trgProp = cpTrgProps.obj.modifiers[cpTrgProps.mLevel]
		default: messageBox "Couldn't get stack level"
		) 

	
-- if mProp is set to #all
	-- get the list of properties to iterate through...
		local propArr = getPropNames srcProp

	-- start iterating and matching
		undo "Copy Properties" on
			(
			format "srcProp: %\n" srcProp
			format "getSubAnimNames srcProp: %\n" (getSubAnimNames srcProp)
			for prop in propArr do
					(
					if hasProperty trgProp prop then
						(
					-- get value and controllers
						local trgPropVal =	getProperty trgProp prop
						local srcPropCtrl =	getPropertyController srcProp prop
						local trgPropCtrl =	getPropertyController trgProp prop
						--format "% | % | %\n" trgPropVal srcPropCtrl trgPropCtrl 
					-- is the property animatable?
--						local propIsAnimatable = (execute("classof "+srcProp+"["+prop+"]")==SubAnim)
--						(execute("classof $.modifiers[1][#angle]"))==SubAnim
--						local propIsAnimatable = (getSubAnim srcProp prop)!= undefined
						local propIsAnimatable = (findItem (getSubAnimNames srcProp) prop)!=0



--						format"srcProp: %\nprop: %\n" srcProp prop
						format"prop : %\n" prop 

						
						--if (classof (getProperty srcProp prop)!=subAnim) then
						if getSubAnim srcProp prop==undefined then
							(
							try (
								-- set controllers if needed
									if cpCopyType>0 AND propIsAnimatable then
										(
										if srcPropCtrl==undefined then setPropertyController srcProp prop (bezier_float())
										if trgPropCtrl==undefined then setPropertyController trgProp prop (bezier_float())
										)
								-- do it!
									-- if it's not animatable, just copy the value
										local copyType
										if propIsAnimatable then copyType = cpCopyType
										else copyType = 1
										--format "copytype: %\npropIsAnimatable: %\n" copyType propIsAnimatable 
									-- start the copy
										case copyType of
											(
											0:	format "CANCELLED\n"
											1:	setProperty srcProp prop trgPropVal
											2:	setPropertyController srcProp prop (copy trgPropCtrl)
											3:	setPropertyController srcProp prop trgPropCtrl
											)
									format "mProp SUCCESS:  % >>> % >>> %\n" srcProp prop trgPropVal
								)
							catch(
								format "mProp FAIL:     % >>> % >>> %\n" srcProp prop trgPropVal
								)
							)
						else
							(
							/*
							try (
								local trgPropCtrl = getPropertyController trgProp prop
								setPropertyController srcProp prop (copy propCtrl)
								format "saProp SUCCESS: % >>> % >>> %\n" trgProp prop trgPropCtrl
								)
							catch(
								format "saProp FAIL:    % >>> % >>> %\n" trgProp prop trgPropCtrl
								)
							*/
							)
					)
				)
			)
	--enableSceneRedraw()
	--forceCompleteRedraw()
	)

--=====================================================================================
-- Go!
--=====================================================================================


--=======================
-- source mode
--=======================
	-- pick source object
		cpMode="src"

		cpSrcProps.obj=$
		if cpSrcProps.obj == undefined then cpSrcProps.obj=pickObject()

	-- build menu
		buildMainMenu cpSrcProps.obj
		registerRightClickMenu cpRCMenu
		popUpMenu cpRCMenu --pos:[0,0]


--=======================
-- target mode
--=======================
	-- pick target object
		cpMode="trg"
		cpTrgProps.obj=pickObject rubberband:cpSrcProps.obj.pos
		buildMainMenu cpTrgProps.obj
		registerRightClickMenu cpRCMenu

	-- build menu
		popUpMenu cpRCMenu

		--format "%\n" cpSrcProps
		--format "%\n" cpTrgProps

	-- do it
		copyProps()
