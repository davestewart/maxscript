macroScript BakeDialog
ButtonText:"Render To Texture..."
category:"Render"
internalcategory: "Render" 
toolTip:"Render to Texture..."

---------------------------------------------------------------------------
--
--	Render to Texture Dialog
--	02/06/02 - Kells Elmquist, discreet3d
--  07/11/03 - Larry Minton, discreet3d
--				TODO: add detection of deleted Unwrap_UVW on working nodes. Now have broadcast on del mod
--  08/19/03 - PFB - removed hardcoded access to the 3dsmax.ini file. Replaced with (GetMAXIniFile())	
--  08/23/03 - LAM - disable radiosity recalculation after first render
(
local	_debug = false -- true -- X
local	_debug2 = false -- true -- X
local	_trackMemory = false -- true -- X

-- these control behaviour of the dialog, and can be changed statically by the user
local	allowControlDisable = false			-- set to true to disable selected element UI controls when element is disabled

local	showCommonElementsOnly = false		-- set to true to show only elements present on all working objects

local	canBakeShapes = true 				-- set to false to disallow baking of shape objects

local	autoUpdateTargetMapSlotName = true	-- set to true to automatically update target slot name on elements if current 
											-- slot name is no longer valid due to change in target material. new slot name 
											-- taken from ini file. Default mappings dynamically defined based on first time 
											-- slot name is specified for combo of element type and material type

local	wipeTextureMapsOnBake = false -- set to true to delete all texturemaps in baked mtl during bake

local	alwaysCreateNewBakeMaterial = false -- set to true to always copy orig mtl to bake mtl during bake

local	use_all_mapping_channels = true		-- set to false to use only Unwrap_UVW generated mapping channels

local	use_all_Unwrap_UVWs = true -- set to false to only consider Unwrap_UVWs named 'Automatic Flatten UVs' as valid channels

local 	allow_manual_unwrap_when_autounwrap_off = false -- set to true to create Unwrap_UVWs when click on "Unwrap Only" even if auto unwrapping turned off

local	defaultMtlShader = #blinn -- shader type to use for new standard materials

local	defaultFileType = ".tga" -- default bitmap file extension 

local	mapPresets = #(64,128,256,512,768,1024) -- NxN map size presets - array size must be 6

local	RTT_MtlName_AppData_Index = 0x41dd73d5 -- used to store data on the material while creating shell materials. Using 5 indices starting at this value
-------------------------------------------------------------------------------------------------


-- these are the globals
global	gTextureBakeDialog	-- the shell holds one instance of each of the other rolloups
struct RTT_data_struct 
(
	overwriteFilesOk,		-- 0 == no overWrite, 1 == ok to overwrite, 2 == ok & not again
	FileOutput_FileType, 	-- output file extension
	FileOutput_FilePath, 	-- output path
	
	AutoFlatten_On, 
	AutoFlatten_Spacing,
	AutoFlatten_ThresholdAngle,
	AutoFlatten_Rotate,
	AutoFlatten_FillHoles,
	AutoFlatten_MapChannel,
	
	AutoSize_SizeMin,
	AutoSize_SizeMax,
	AutoSize_SizeScale,
	AutoSize_SizePowersOf2,
	
	Renderer_DisplayFB,
	Renderer_NetworkRender,
	Renderer_SkipExistingFiles,
	
	OutputMapSize_AutoMapSize,
	OutputMapSize_Width,
	OutputMapSize_Height,
	
	Materials_RenderToFilesOnly,
	Materials_MapDestination,
	Materials_DuplicateSourceOrCreateNew,

	Dialog_CommonBakeProps_Open,
	Dialog_SelectedObjectProps_Open,
	Dialog_SelectedElementProps_Open,
	Dialog_BakedMtlProps_Open,
	
	rendererErrorDisplayed, 	-- true if "renderer doesn't support texture baking" warning displayed. Set to true to not display warning
	netRenderErrorDisplayed		-- true if "backburner not installed" warning displayed. Set to true to not display warning

)

global RTT_data		-- initialized at first execution

-- the main rollouts
local	commonBakeProps 
local	selectedObjectProps
local	selectedElementProps
local	bakedMtlProps

-- various object lists s
local	selectedObjects = #() -- the selected objects. Contains nodes
local	displayedBakableObjects = #() -- the selected objects that are bakable. Contains bakableObjStruct instances
local	workingObjects = #() -- the current working objects. Contains bakableObjStruct instances

-- displayed bake element data
local	selectedElement -- currently selected effect if 1 and only 1, undefined otherwise
local	selectedElementIndex = 0 -- which entry in commonElements we are displaying data for
local	selectedElementLVIndex = 0 -- which entry in elements ListView we are displaying data for
local	commonElements = #( ) -- array of array of bake elements with common name across working objects
local	commonElementsTargIndet = #{} -- bitarray specifying whether corresponding commonElements have indeterminate target

local	ignoreSelectionUpdates = false -- flag to ignore selection updates because a temp selection change is being made

local	curBM = undefined -- the current bitmap being displayed during render

local	newBakedMtlInstance -- instances of this material will be used as new baked material. Initialized in bakedMtlProps
local	newBakedMtlTargetMapNames-- will contain the target map names for newBakedMtlInstance
local	newNodeMtlInstance -- instances of this material will be used as new node material when none exists. Initialized in gTextureBakeDialog
local	newNodeMtlTargetMapNames -- will contain the target map names for newNodeMtlInstance

local	overwriteFileName = "" -- filename used by fileOverwriteBox rollout

local	updateFileNames  -- stores element file names for setting element file name after rendering a sequence.

local	autoUnwrapChannel -- Auto Unwrap Mapping channel. Initialized in commonBakeProps
local	doAutoUnwrap -- true when Auto Unwrap Mapping turned on, false otherwise. Initialized in commonBakeProps

local	renderPresetFiles = #() -- list of render preset files. Pulled from the current .ini [RenderPresetsMruFiles] section.

local	unwrapUVW_instance -- will hold instance of Unwrap_UVW modifier. Used in ObjectIsBakable. Initialized in gTextureBakeDialog

------------------------------------------------------------------------
--
-- persistant dialog size & position
--
local   pDialogHeight
local   pDialogPos
local	pFileOverwriteBoxPos
local	pMissingMapCoordsPos
local	pMissingMapTargetsPos
local	pMissingMapFilesPos
local	pAddElementsPos
local	pInvalidOutDirPos

--------------------------------------------------------------------------
--
--	ini files
--
-- this is the dialog state ini file, holds persistent dialog state
local 	iniFile = "$plugcfg/BakeTexture.ini"

-- various structures 
-- bakableObjStruct: stores node, node name, bitArray of UVW map channels defined, texmap names for node's mtl, and whether a working object
-- if node doesn't have a mtl, default mtl is standard mtl using 'defaultMtlShader' shader
struct bakableObjStruct (node, nodeName, channels, mapSlotNames, isWorkingObject = false)

struct bakeElementStruct (element, node) -- stores element and node containing element

struct RTT_MlTypes (name,instance) -- stores name and instance of material

struct triStateValue -- tracks if variable has been set to no, one, or move than one value
(	defined = false,  -- true if at least one value has been "set"
	indeterminate = true, -- different values have been "set"
	value = undefined,  -- current value if defined and determinate
	function setVal val = -- use this to "set" the value
	(	if defined then
		(	if val != value then
			(	indeterminate = true
				value = undefined
			)
		)
		else
		(	indeterminate = false
			defined = true
			value = val
		)
	),
	function asTriState = -- returns value that can be used for checkBox.triState property. 'value' must be a boolean
		if indeterminate then 2 else if value then 1 else 0
)

-- some forward declarations of functions
local	GetINIConfigData, SetINIConfigData 

----------------------------------------------------------------------------
-- this function is used everywhere to determine if an object can be baked
function ObjectIsBakable _obj =
(
	local objClass = classof _obj
	local isBakable = (superclassof _obj == geometryClass or (canBakeShapes and superclassof _obj == shape)) \
			and (objClass != Spray ) \ 
			and (objClass != SuperSpray ) \ 
			and (objClass != PCloud ) \ 
			and (objClass != PArray ) \ 
			and (objClass != Snow ) \ 
			and (objClass != Blizzard ) \ 
			and (objClass != Targetobject ) \
			and (objClass != PF_Source) \
			and (objClass != ParticleGroup) \
			and ( _obj.isHidden == false ) \
			and ( _obj.isFrozen == false ) \
			and (validModifier _obj unwrapUVW_instance ) \
			and (local m = snapshotasmesh _obj; local res = m.numfaces != 0; delete m; res)
	--format "superClass = %, class = %, isBakable = % \n" (superclassof _obj) objClass isBakable
	return isBakable
)

-- the unwrapper returns 0 for channel 1 (0,2,3..) for strange historical reasons
function GetMapChannel _unwrapMod =
(
	local n = _unwrapMod.getMapChannel()
	return (amax 1 n)
)	

-- function to return bitArray of mapping channels on node
function GetNodeMapChannels _obj =
(
	local m = snapshotasmesh _obj
	local n = meshop.getNumMaps m
	local ba = #{}
	ba.count = n
	local fn_getMapSupport = meshop.getMapSupport 
	for i = 1 to n do ba[i]=fn_getMapSupport m i
	delete m
	ba
)

-- function to return bitArray of Automatic Flatten channels on node
function CollectAutoFlattenChannels _obj =
(
	local res = #{}
	for mod in _obj.modifiers where 
		(classof mod == Unwrap_UVW and (use_all_Unwrap_UVWs or mod.name == "Automatic Flatten UVs")) do
		res[(GetMapChannel mod)] = true
	return res
)

-- function to return the valid mapping channels on a node
function CollectMappedChannels _obj =
(
	if use_all_mapping_channels then
		GetNodeMapChannels _obj
	else
		CollectAutoFlattenChannels _obj
)

-- function to delete the autoFlattener on an object
function DeleteAutoFlatten _obj =
(
	-- test each modifier on the object. Count down since we may be deleting modifiers
	for nMod = _obj.modifiers.count to 1 by -1 do
	(
		-- get the next modifier
		local unwrapMod = _obj.modifiers[ nMod ]
		
		if (classof unwrapMod) == Unwrap_UVW then
		(
			-- it's an unwrap modifier, 
			if unwrapMod.name == "Automatic Flatten UVs" then
			(
				--format "removing auto unwrapper: % \n" unwrapMod.name
				deleteModifier _obj unwrapMod
			)
		) -- end, it's an unwrapper
	) -- end, for each modifier
)

-- function to remove shell materials from an object
function DeleteBakeMaterial _curObj =
(
	-- if the material is a shell material, lose it
	local materialType = classof _curObj.material
	if _debug do format "\tremoving bake material on %; mtltype: %\n" _curObj.name materialType 
	-- format "material type = %\n" materialType
	
	if (materialType == Shell_Material) then
	(
		if _debug do format "\tDeleteBakeMaterial - _curObj: %\n" _curObj.name
		if (_curObj.material.bakedMaterial != undefined) do
			showTexturemap _curObj.material _curObj.material.bakedMaterial false

		local origName = getAppData _curObj.material (RTT_MtlName_AppData_Index+2)
		if ( origName == undefined) do
			origName = _curObj.material.originalMaterial.name

		_curObj.material.originalMaterial.name = origName
		local old_autoMtlPropagation = instancemgr.autoMtlPropagation
		instancemgr.autoMtlPropagation = false
		_curObj.material = _curObj.material.originalMaterial 
		instancemgr.autoMtlPropagation = old_autoMtlPropagation 
		
	) -- end, has shell material
	else if (_curObj.material != undefined) then
	(
		-- not a shell material, look at each sub-material and see if it is a shell material
		-- if so, replace the shell material with the shell material's original material
		local mtl = _curObj.material
		local nmtls = getNumSubMtls mtl
		for i = 1 to nmtls do
		(	smtl = getSubMtl mtl i
			if classof smtl == Shell_Material then
			(	
				local origName = getAppData smtl (RTT_MtlName_AppData_Index+2)
				if ( origName == undefined) do
					origName = smtl.originalMaterial.name

				smtl.originalMaterial.name = origName 
				setSubMtl mtl i smtl.originalMaterial
				--format "remove bake material in %\n" mtl 
			)
		)
	) -- end, non-shell material
)

---------------------------------------------------------------------------
--
--	Function to auto-flatten the objects from a list
--
function BatchFlatten _ObjectList flattenAngle flattenSpacing flattenRotate flattenFillHoles flattenAll:false =
(
	undo "Flatten Objects" on
	(
		if _debug do format "flatten % objects \n" _ObjectList.count
		
		-- first put up the progress dialog
		rollout flattenProgress "Progress..." width:183 height:46
		(
			label lbl1 "Flattening UV's..."
				pos:[48,5] width:94 height:21
			progressBar pb1 "" 
				pos:[5,21] width:174 height:17
		)
		createdialog flattenProgress pos:((sysinfo.DesktopSize/2)-[100,250]) -- style:#(#style_border,#style_toolwindow)
		local progressScale = 100. / (_ObjectList.count + 1)
		flattenProgress.pb1.value = progressScale 
	
		-- must be in modify mode to use flatten operator
		if (getCommandPanelTaskMode() != #modify) do setCommandPanelTaskMode mode:#modify
		
		with redraw off
		(
			-- for each object...
			local nObj = 0
			local patchErrorDisplayed = false 
			for curObj_i in _ObjectList do
			(
				local curObj = curObj_i.node
				local bakeInterface = curObj.INodeBakeProperties
				nObj += 1
				
				-- bit 1 of flag will be set to signify map channel conflict
				bakeInterface.flags = bit.set bakeInterface.flags 1 false

				if (not flattenAll and not bakeInterface.effectiveEnable()) then
				(
					if _debug do format "\tignoring object: % \n" curObj.name
					continue
				)
				
				-- get rid of sub-object selections
--				local hasSubObjectSelections = false
				local curClass = classof curObj
				--format "object class = % \n" curClass
				
				if not patchErrorDisplayed then -- just display warning message once
				(	if (curClass == Editable_Patch) or (curClass == quadPatch) or (curClass == triPatch) then
					(	messageBox "Editable patch objects not currently supported for flattening and may produce poor results."
						patchErrorDisplayed = true
					)
				)
					
--				if (curClass == Editable_mesh) or (curClass == Editable_poly) then
--				(
--					objSelections = getFaceSelection( curObj )
--					format "undo subobject selection: % \n"	(objSelections as string)
--					setFaceSelection( curObj )( #() )
--					hasSubObjectSelections = true
--				)
				
				local unwrapMod
				local hasModifier = false
				local skipObject = false
				local bakeChannel = bakeInterface.bakeChannel 
				local autoFlattenModsToDelete = #() -- collection of modifiers to delete. Need to delete after looping through modifiers
				-- test each modifier on the object. 
				for nMod = 1 to curObj.modifiers.count while ((not skipObject) and (not hasModifier)) do
				(
					-- get the next modifier
					unwrapMod = curObj.modifiers[ nMod ]
					
					--format "modifier class = % \n" (classof unwrapMod as string)
					if (classof unwrapMod) == Unwrap_UVW then
					(
						---format "class Unwrap_UVW\n"
						
						-- it's an unwrap modifier, 
						if unwrapMod.name == "Automatic Flatten UVs" then
						(
							--format "has auto unwrapper: % \n" unwrapMod.name
					
							-- If force re flatten is on and the object has the right modifiers, 
							hasModifier = true
							
							-- compare against previous global settings for changes
							--format "channel= %, angle = %, spacing = %,   normalize = % rotate = %, fill = %\n" \
							--	(unwrapMod.getMapChannel())(unwrapMod.getFlattenAngle())(unwrapMod.getFlattenSpacing()) \
							--	(unwrapMod.getFlattenNormalize())(unwrapMod.getFlattenRotate())(unwrapMod.getFlattenFillHoles())
	
							--format "mod channel= %, obj channel = %\n" (unwrapMod.getMapChannel()) (curObj.bakeChannel)
	
							-- the baked material has bad uv coords if these don't match
							if ( (GetMapChannel unwrapMod) != bakeChannel ) then
								DeleteBakeMaterial curObj
	
							if unwrapMod.getPreventFlattening() == false  \
							   and (    ( GetMapChannel unwrapMod != bakeChannel ) \
									 or ( unwrapMod.getFlattenAngle() != flattenAngle ) \
									 or ( unwrapMod.getFlattenSpacing() != flattenSpacing ) \
									 or ( unwrapMod.getFlattenRotate() != flattenRotate ) \
									 or ( unwrapMod.getFlattenFillHoles() != flattenFillHoles ) 
								   ) then
							(
								--format "Update unwrap_uvw\n"
								
								if ( (GetMapChannel unwrapMod) == bakeChannel ) do  -- otherwise already done above
									DeleteBakeMaterial curObj
								append autoFlattenModsToDelete unwrapMod
								hasModifier = false		-- force new modifier
								
							) -- end, unwrapper not locked
							else (
								--format "no change in object: % \n" (curObj as string)
							)
	
						) -- end, has autoflatten unwrapper
						else if ( (GetMapChannel unwrapMod) == bakeChannel ) then
						(
							-- channel match, it's a user unwrapper for this obj, leave it alone
							--format "non-automatic unwrapper found with matching channel\n"
							hasModifier = true
						) else (
							--format "non-automatic unwrapper found with un-matched channel= % \n" (unwrapMod.getMapChannel())
						)	
					) -- end, is unwrap modifier
					else (
						--format "object class = %\n" (classof unwrapMod as string)
						if (classof unwrapMod) == Uvwmap then
--								or (classof unwrapMod) == UVW_Xform then
						(
							--format "is uvwmap\n"
							-- potential mapping channel conflict
							local mapChan = unwrapMod.mapChannel
							if mapChan == 0 then mapChan = 1
							if( mapChan == bakeChannel ) then 
							(	local errmsg = "Map Channel in UVW_Mapping modifier conflicts with the channel specified for render to texture. Select a different render to texture channel.\n"
								append errmsg ("Node: " + curObj.name + "\n")
								append errmsg ("Channel: " + bakeChannel as string)
								messageBox errmsg title:"Map channel conflict"
								skipObject = true
								-- set bit 1 of flag signify conflict
								bakeInterface.flags = bit.set bakeInterface.flags 1 true
							)
						)
					)
	
				)-- end, for each modifier
				
				-- delete the unwanted modifiers
				for mod in autoFlattenModsToDelete do deleteModifier curObj mod

				if _debug do format "\tprocessing object: %; % - % \n" curObj.name hasModifier skipObject

				-- If the object doesn't have a modifier applied, create one and flatten it
				if (not hasModifier) and (not skipObject) then
				(
					-- create a new autoflatten unwrapper
					--format "Create new unwrap_uvw\n"
					unwrapMod = unwrap_UVW()
					
					unwrapMod.setAlwaysEdit false
					unwrapMod.setMapChannel bakeChannel
					unwrapMod.setFlattenAngle flattenAngle 
					unwrapMod.setFlattenSpacing flattenSpacing 
					unwrapMod.setFlattenNormalize true
					unwrapMod.setFlattenRotate flattenRotate 
					unwrapMod.setFlattenFillHoles flattenFillHoles 
					unwrapMod.setApplyToWholeObject true
					unwrapMod.name = "Automatic Flatten UVs"
					unwrapMod.setDebugLevel 0
					
					-- add it to the object
					-- add directly to the object to avoid groupness
					addModifier curObj unwrapMod
					
					local restoreToGroup = false
					if (isGroupMember curObj) then
					(
						setGroupMember curObj false
						restoreToGroup = true
					)
					-- select the object to apply flatten operator
					with undo off select curObj
				
					-- & flatten things
					unwrapMod.flattenMap \
						flattenAngle  \
						#([1,0,0],[-1,0,0], [0,1,0],[0,-1,0], [0,0,1],[0,0,-1]) \
						flattenSpacing  \
						true \
						2 \
						flattenRotate  \
						flattenFillHoles 
					-- or use instead of true: commonBakeProps.cNormalize.checked \
					
					-- if it was in a group put it back
					if restoreToGroup then
						setGroupMember curObj true

				) -- end, create new unwrapper
				
					
--				if hasSubObjectSelections then
--					setFaceSelection curObj objSelections
	
				-- update the progress bar
				flattenProgress.pb1.value = progressScale * (nObj + 1)
				
				curObj_i.channels = CollectMappedChannels curObj_i.node
							
			) -- end, for each object
			with undo off if selectedObjects.count != 0 then select selectedObjects else clearSelection()	-- reselect
		) -- end, with redrawOff
		
		-- Auto Flatten endgame
		destroydialog flattenProgress
	) -- end - undo "Flatten Objects" on
) -- end -function BatchFlatten 

-------------------------------------------------
-- test the filename for the element
-- tests & sets fileUnique, default extension
-- returns filename to display
--
function CheckBakeElementFileName _obj _element _eleName _newName _defaultPath = 
(
	if _debug do format "check file name:\t%, %, %, %, %\n" _obj.name _element _eleName _newName _defaultPath
	if _debug do format "\t\t\t%, %, %, %\n" _element.elementName _element.filenameUnique _element.fileName _element.fileType
	local res = undefined
	with undo off -- no undo records for element changes...
	(
		if (_newName == undefined) or (_newName == "") then
		(
			saveName = _element.elementName -- save
			_element.elementName = _eleName	-- temporary write for makefilename
			_element.filenameUnique = false -- allow overwrite by auto file name
			_newName = RTT_methods.MakeBakeElementFileName _obj _element "" "" defaultFileType 
			_element.elementName = saveName	-- & restore
			res = _newName
		)
		else 
		(
			-- first check the path
			local pathsTheSame
			local newPath = getFilenamePath _newName
			if (newPath == "") then
				pathsTheSame = true 
			else
			(
				local defaultPath = copy _defaultPath
				local i
				while ((i=findString newPath "/") != undefined) do newPath[i]="\\"
				while ((i=findString defaultPath "/") != undefined) do defaultPath[i]="\\"
				pathsTheSame = (stricmp newPath defaultPath) == 0
			)
			if _debug do format "\tpathsTheSame: %; %, %\n" pathsTheSame newPath _defaultPath
			
			-- now check the filenames w/o path and extension
			
			local curName = getFilenameFile _newName
			-- generate the default name for the element
			local genName = RTT_methods.MakeFileNameValid (_obj.name + _eleName)
			if _debug do format "\tnames: % - % - %\n" _newName curName genName
			_element.filenameUnique = (curName != genName)
			
			-- check extension. set as new default
			local newType = getFilenameType _newName
			if (newType == "") do newType = defaultFileType
			defaultFileType = newType
			
			if pathsTheSame then
				res = curName + newType
			else
				res = (getFilenamePath _newName) + curName + newType
			if _debug do format "\tfilenameUnique: %, %\n" _element.filenameUnique res
			
		) -- end, else new name not empty 
	) -- end, undo off 
	return res
) -- end - function CheckBakeElementFileName 

-- this function clears all the textures on a material and its first level subMaterials
-- if the mtl or subMtl is a shell, use shell's baked material instead
function ClearTextures mtl doSubMtls:true topMtl: =
(
	if _debug do format "ClearTextures, mtl = %\n" mtl

	if topMtl == unsupplied do topMtl = mtl
	
	if classof mtl == Shell_Material do
	(
		mtl = mtl.bakedMaterial 
		doSubMtls = false -- don't walk down 
	)
	
	local nmaps = getNumSubTexmaps mtl
	for i = 1 to nmaps do 
	(	local stex = getSubTexmap mtl i
		if stex != undefined do
		(
			showTexturemap topMtl stex false
			setSubTexmap mtl i undefined
		)
	)

	if doSubMtls do
	(
		local nmtls = getNumSubMtls mtl
		for i = 1 to nmtls do
		(	local smtl = getSubMtl mtl i
			if smtl != undefined do 
				ClearTextures smtl doSubMtls:false topMtl:topMtl
		) 
	)
) -- end - function ClearTextures 

-- this function sets whether Original or Baked Material is used in Viewport for shell materials. 
function SetShellMtlVPMtl mtl which doSubMtls:true topMtl: =
(
	if _debug do format "SetShellMtlVPMtl, mtl = %\n" mtl

	if topMtl == unsupplied do topMtl = mtl

	if classof mtl == Shell_Material do
	(
		if _debug do format "SetShellMtlVPMtl - which = %, mtl.viewportMtlIndex = %\n" which mtl.viewportMtlIndex 
		local amtl 
		if (mtl.viewportMtlIndex != which) do
		(
			amtl = if mtl.viewportMtlIndex == 0 then mtl.originalMaterial else mtl.bakedMaterial 
			if _debug do format "SetShellMtlVPMtl - showTexturemap 1, topMtl = %, amtl = %\n" topMtl amtl 
			if amtl != undefined do showTexturemap topMtl amtl false
			if _debug do format "SetShellMtlVPMtl - showTexturemap 1 done\n"
			mtl.viewportMtlIndex = which
			doSubMtls = false -- don't walk down 
		)
		amtl = if which == 0 then mtl.originalMaterial else mtl.bakedMaterial 
		if _debug do format "SetShellMtlVPMtl - showTexturemap 2, topMtl = %, amtl = %\n" topMtl amtl 
		if amtl != undefined do showTexturemap topMtl amtl true
		if _debug do format "SetShellMtlVPMtl - showTexturemap 2 done\n"
	)
	
	if doSubMtls do
	(
		local nmtls = getNumSubMtls mtl
		for i = 1 to nmtls do
		(	local smtl = getSubMtl mtl i
			if smtl != undefined do 
				SetShellMtlVPMtl smtl which doSubMtls:false topMtl:topMtl
		) 
	)
) -- end - function SetShellMtlVPMtl

-- this function returns whether Original or Baked Material is used in Viewport for shell materials. 
-- res is a triStateValue
function GetShellMtlVPMtl mtl res doSubMtls:true =
(
	if _debug do format "GetShellMtlVPMtl, mtl = %; res: %\n" mtl res

	if classof mtl == Shell_Material do
	(
		res.setVal mtl.viewportMtlIndex
		doSubMtls = false -- don't walk down 
	)
	
	if doSubMtls do
	(
		local nmtls = getNumSubMtls mtl
		for i = 1 to nmtls do
		(	local smtl = getSubMtl mtl i
			if smtl != undefined do 
				GetShellMtlVPMtl smtl res doSubMtls:false
		) 
	)
) -- end - function GetShellMtlVPMtl


-- this function sets whether Original or Baked Material is used in Renders for shell materials. 
function SetShellMtlRenderMtl mtl which doSubMtls:true topMtl: =
(
	if _debug do format "SetShellMtlRenderMtl, mtl = %\n" mtl

	if topMtl == unsupplied do topMtl = mtl

	if classof mtl == Shell_Material do
	(
		if _debug do format "SetShellMtlRenderMtl - which = %, mtl.renderMtlIndex = %\n" which mtl.viewportMtlIndex 
		mtl.renderMtlIndex = which
		doSubMtls = false -- don't walk down 
	)
	
	if doSubMtls do
	(
		local nmtls = getNumSubMtls mtl
		for i = 1 to nmtls do
		(	local smtl = getSubMtl mtl i
			if smtl != undefined do 
				SetShellMtlRenderMtl smtl which doSubMtls:false topMtl:topMtl
		) 
	)
) -- end - function SetShellMtlRenderMtl 

-- this function returns whether Original or Baked Material is used in Renders for shell materials. 
-- res is a triStateValue
function GetShellMtlRenderMtl mtl res doSubMtls:true =
(
	if _debug do format "GetShellMtlRenderMtl, mtl = %; res: %\n" mtl res

	if classof mtl == Shell_Material do
	(
		res.setVal mtl.renderMtlIndex
		doSubMtls = false -- don't walk down 
	)
	
	if doSubMtls do
	(
		local nmtls = getNumSubMtls mtl
		for i = 1 to nmtls do
		(	local smtl = getSubMtl mtl i
			if smtl != undefined do 
				GetShellMtlRenderMtl smtl res doSubMtls:false
		) 
	)
) -- end - function GetShellMtlRenderMtl

-- this function sets the textures on a material and its first level subMaterials given the slot name
-- if the mtl or subMtl is a shell, use shell's baked material instead
function SetNamedSubTexmap mtl theName theTexmap doSubMtls:true =
(
	if _debug do format "\t\tset texture, mtl: %; name: %; texmap: %\n" mtl theName theTexmap 

	if classof mtl == Shell_Material do
	(
		mtl = mtl.bakedMaterial 
		doSubMtls = false -- don't walk down 
	)
	
	local nmaps = getNumSubTexmaps mtl
	local notFound = true 

	-- special case code for standard materials. If putting to the ambient slot, and ambient texmap
	-- was previously not set, turn off the ambient lock flag
	local checkAmbientLockFlag = (classof mtl == standard) and (isProperty mtl #ambientMap) and (mtl.ambientMap == undefined)

	-- special case code for standard materials. If not putting to Source material, turn off basic parameter flags
	if (classof mtl == standard) and (bakedMtlProps.rbDestination.state == 2) do
	(
		mtl.wire = mtl.twoSided = mtl.faceted = mtl.faceMap = off
		if (isProperty mtl #selfIllumAmount) do mtl.selfIllumAmount = 100 -- not present for Strauss shader
	)

	-- special case code for Architectural materials. If not putting to Source material, set Raw Diffuse Texture on
	if (classof mtl == Architectural) and (bakedMtlProps.rbDestination.state == 2) do
		mtl.rawDiffuseTexture = on
	
	for i = 1 to nmaps while notFound where ((stricmp (getSubTexmapSlotName mtl i) theName) == 0) do 
	(
		if _debug do format "\t\tset texture slot: %\n" theName
		local oldMap = getSubTexmap mtl i 
		if oldMap != undefined do showTexturemap mtl oldMap false
		setSubTexmap mtl i theTexmap
		notFound = false
	)

	if checkAmbientLockFlag and mtl.ambientMap != undefined and mtl.adTextureLock do 
		mtl.adTextureLock = false

	if doSubMtls do
	(
		local nmtls = getNumSubMtls mtl
		for i = 1 to nmtls do
		(	local smtl = getSubMtl mtl i
			if smtl != undefined do 
				SetNamedSubTexmap smtl theName theTexmap doSubMtls:false
		) 
	)
) -- end - function SetNamedSubTexmap 

-- this applies maps, via the element-to-mapChannel mapping specified in the element, to the given material,
function ApplyElementsToMtl _obj _toMtl =
(	
	if _debug do format "\tapplyElementsToMtl _obj:% _toMtl:%\n" _obj _toMtl

	local bakeInterface = _obj.INodeBakeProperties

	-- for each possible bake element
	local nBakeElements = bakeInterface.NumBakeElements()
	for nEle = 1 to nBakeElements do
	(
		local theElement = bakeInterface.GetBakeElement nEle 
		local target_name = theElement.targetMapSlotName

		if theElement.enabled and target_name != "" and target_name != " " then -- skip disabled elements and elements w/o target slots
		(	
			local fname = theElement.fileType
			if fname == undefined or fname == "" then
			(
				fname = commonBakeProps.GetFilePath() + theElement.fileName
			)
			local theTexmap = bitmapTexture filename:fname
			theTexmap.coords.mapChannel = bakeInterface.bakeChannel 
			SetNamedSubTexmap _toMtl target_name theTexmap 
		)
		
	) -- end, for each element
) -- end, function ApplyElementsToMtl 

------------------------------------------------------------------
--
--	Function to update the output material & create shells if needed
--
function UpdateMaterial _obj =
(
	if _debug do format "\tupdateMaterial - node: % \n" _obj.name
	
	local mtl = _obj.material
	if mtl == undefined do -- no material on node. Create new default material
	(
		local old_autoMtlPropagation = instancemgr.autoMtlPropagation
		instancemgr.autoMtlPropagation = false
		mtl = _obj.material = copy newNodeMtlInstance
		instancemgr.autoMtlPropagation = old_autoMtlPropagation 
		if classof mtl == StandardMaterial do mtl.diffuse=_obj.wireColor
		mtl.name = _obj.name + "_mtl"
		setAppData mtl RTT_MtlName_AppData_Index mtl.name
		setAppData mtl (RTT_MtlName_AppData_Index+1) "N"
		if _debug do format "\t\tapplied new material: %\n" mtl
	)
	
	local materialType = classof mtl
	local nmtls = getNumSubMtls mtl
	if _debug do format "\tMaterial Type: %; nmtls: %; dest: %; opt: %\n" materialType nmtls bakedMtlProps.rbDestination.state bakedMtlProps.rbShellOption.state

	if (bakedMtlProps.rbDestination.state == 2) then -- Save Source (Create Shell)
	(
		if (materialType != Shell_Material) then -- wrap existing material in a shell if not already a shell
		(
			local newMaterial = Shell_Material()
			newMaterial.name = getAppData mtl RTT_MtlName_AppData_Index
			setAppData newMaterial (RTT_MtlName_AppData_Index+2) newMaterial.name 
			newMaterial.name += (" [" + _obj.name + "]")
			if (getAppData mtl (RTT_MtlName_AppData_Index+1) == "N") do
			(
				mtl.name = "orig_" + mtl.name
				setAppData mtl (RTT_MtlName_AppData_Index+1) "Y"
			)
			if _debug do format "\t\tapplied new shell material: % : %\n" newMaterial mtl
			newMaterial.originalMaterial = mtl
			newMaterial.bakedMaterial = undefined
			local old_autoMtlPropagation = instancemgr.autoMtlPropagation
			instancemgr.autoMtlPropagation = false
			mtl = _obj.material = newMaterial
			instancemgr.autoMtlPropagation = old_autoMtlPropagation 
		)
		else
		(
			if mtl.originalMaterial == undefined do
			(
				mtl.originalMaterial = copy newNodeMtlInstance
				mtl.originalMaterial.name = "orig_" + mtl.name
			)
		)
		
		local origName = getAppData mtl (RTT_MtlName_AppData_Index+2)
		if ( origName == undefined) do
		(
			origName = mtl.originalMaterial.name
			setAppData mtl (RTT_MtlName_AppData_Index+2)  origName
		)
		
		local bakeTarget = mtl.bakedMaterial
		-- always create bakedMaterial if it doesn't exist, otherwise just optionally
		if (alwaysCreateNewBakeMaterial or bakeTarget == undefined) then
		(	if (bakedMtlProps.rbShellOption.state == 1) then -- Duplicate Source to Baked
			(
				-- copy mtl from orig to baked, optionally delete texmaps from baked
				bakeTarget = copy mtl.originalMaterial
				if wipeTextureMapsOnBake do 
					ClearTextures bakeTarget
				if _debug do format "\t\tcopy mtl from orig to baked\n"
			)
			else -- Create New Baked
			(
				bakeTarget = copy newBakedMtlInstance
				if classof bakeTarget == StandardMaterial do bakeTarget.diffuse=_obj.wireColor
				if _debug do format "\t\tcreated new baked\n"
			)
			bakeTarget.name = "baked_" + origName
		)
		else
		(
			if _debug do format "\t\tbaked already exists: %\n" bakeTarget
			-- optionally delete texmaps from baked
			if wipeTextureMapsOnBake do 
				ClearTextures bakeTarget
		)
		
		-- apply the element bitmaps to the baked mtl and assign
		ApplyElementsToMtl _obj bakeTarget
		mtl.bakedMaterial = bakeTarget
		
		-- which material do we use for the viewport
		local which = gTextureBakeDialog.rOrigOrBaked.state
		if which == 0 do which = 2 -- if indeterminate, use Baked
		SetShellMtlVPMtl mtl (which-1)

		-- which material do we use for the rendering
		which = gTextureBakeDialog.rOrigOrBaked2.state
		if which == 0 do which = 1 -- if indeterminate, use Original
		SetShellMtlRenderMtl mtl (which-1)
	)
	else -- Output Into Source
	(
		if _debug do format "\t\tOutput Into Source\n"
		ApplyElementsToMtl _obj mtl
	)
	
	if _debug do format "\tend update material\n"

) -- end - function UpdateMaterial

----------------------------------------------------------------------------
--
-- these routines collect the file names for a frame & then applys them
-- prior to material updating
--
function CollectUpdateFiles _obj =
(
	--format "on object: % \n" _obj.name
	local bakeInterface = _obj.INodeBakeProperties
	local nElements = bakeInterface.numBakeElements()
	for i = 1 to nElements do
	(
		-- get the element
		local ele = bakeInterface.getBakeElement i
		
		-- save the file name,
		if updateFileNames[ i ] == undefined do updateFileNames[ i ] = #()
		append (updateFileNames[ i ]) ele.fileType
--		format "	save filename = %\n" ele.fileType
	)
) -- end - function CollectUpdateFiles 

-- apply collected filenames to object elements
function ApplyUpdateFiles _obj =
(
--	format "restore files on object: % : %\n" _obj.name updateFileNames
	local bakeInterface = _obj.INodeBakeProperties
	local nElements = bakeInterface.numBakeElements()
	with undo off -- no undo records for element changes...
	(
		for i = 1 to nElements do
		(
			-- get the element
			local ele = bakeInterface.getBakeElement i
			
			-- restore the file name,
			local outfileArray = updateFileNames[ i ]
			if outfileArray.count != 1 then
			(	
				local path = getFilenamePath (outfileArray[1])
				local theName
				if (ele.filenameUnique) and ( ele.filename != "" ) then
				(
					-- unique name
					theName = getFilenameFile ele.filename
				) 
				else 
				(
					-- it's a non-unique name, generate it
					theName = RTT_methods.MakeFileNameValid (_obj.name + ele.elementName)
				)
				theName = path + theName + ".ifl"
				outfile = openfile theName mode:"w"
				for f in outfileArray do 
					format "%\n" (filenameFromPath f) to:outfile
				close outfile
				
				ele.fileType = theName 
			)
			else
				ele.fileType = outfileArray[1] 
		
			-- format "	restore filename = %\n" ele.fileType
		)
	)
) -- end - function ApplyUpdateFiles 

-----------------------------------------------------------------------------
--
--	these functions remove the flatteners, shell & baked materials from a scene
--	reattaching the original materials to the nodes
--
function RemoveFlatteners =
(
	--format "remove flatteners\n"
	undo "Clear Unwrappers" on
	(
		for obj in workingObjects do
			DeleteAutoFlatten obj.node
	)
) -- end - function RemoveFlatteners
						
function RemoveBakeMaterials =
(
	--format "remove bake materials\n"
	undo "Clear Shell Mtls" on
	(
		for obj in workingObjects do
			DeleteBakeMaterial obj.node
	)
	
) -- end - function RemoveBakeMaterials 

----------------------------------------------------------------------------
--
--	Routines to handle file checking
--
-- message box to confirm overwrite of existing files
rollout fileOverwriteBox "File Exists" width:400 height:113
(
	button bCancel "Cancel Render" pos:[202,63] width:92 height:24
	button bOverwriteFiles "Overwrite Files" pos:[99,63] width:87 height:24
	checkbox cNotAgain "Don't show again" pos:[10,90] width:120 height:18 checked:false 
	groupBox gFile "Confirm File Overwrite:" pos:[3,8] width:396 height:50
	edittext eFileName "" pos:[4,27] width:390 height:22 enabled:false

	on fileOverwriteBox open do
	(
		-- format "conflicted filename = %,   val = % \n" overwriteFileName overwriteVal 
		eFilename.text = overwriteFileName 
	)
	
	on fileOverwriteBox close do
	(	
		pFileOverwriteBoxPos = GetDialogPos fileOverwriteBox 
	)
	on bCancel pressed do 
	(
		RTT_data.overwriteFilesOk = 0
		destroydialog fileOverwriteBox
	)
	on bOverwriteFiles pressed do
	(
		RTT_data.overwriteFilesOk= if cNotAgain.checked then 2 else 1
		destroydialog fileOverwriteBox
	)
	
) -- end, file overwrite dialog


-- returns true if ok to overwrite 
function OkToOverwrite _fileName =
(
	if RTT_data.overwriteFilesOk < 2 then -- if 0 or 1 ...
	(
		overwriteFileName = _fileName
		createDialog  fileOverwriteBox  modal:true pos:pFileOverwriteBoxPos
	)		
	return( RTT_data.overwriteFilesOk > 0 )
) -- end - function OkToOverwrite 

-- resets the "don't ask again" flag
function ResetFileOverwrite = 
( 
	RTT_data.overwriteFilesOk = 0 
)

-- function to see if files to be created by node's elements already exist, then check if ok to over write it.
function CheckFileOverwrite _obj =
(
	local bakeInterface = _obj.INodeBakeProperties
	local nElements = bakeInterface.numBakeElements()
	res = true
	for i = 1 to nElements while res and (RTT_data.overwriteFilesOk != 2) do
	(
		-- get the element
		local ele = bakeInterface.getBakeElement i
		
		-- see if the file exists
		if doesFileExist ele.fileType then
		(
			--format "file exists: % \n" (ele.fileType)
			-- it exists, what do we do?
			if OkToOverwrite ele.fileType then
			(
				--format "ok to overwrite file\n"
			) else (
				--format "cancel\n"
				res = false -- cancel render
			)
				
		) -- end, file exists
	) -- end, for each element
	
	return res
) -- end - function CheckFileOverwrite 

-------------- function to skip objects w/ map conflicts
function ObjHasMapConflicts _obj =
(
	bit.get _obj.INodeBakeProperties.flags 1
)

-- function to check to make sure needed UVW coords are present
-- returns true if ok to render, false if not
--
function MapCoordsOK _ObjectList =
(
	rollout missingMapCoordsRO "Missing Map Coordinates - RTT" width:300
	(
		local itemList = #()
		group ""
		(	label lbl1 "The following objects require map coordinates and" align:#left offset:[0,-10]
			label lbl2 "may not render correctly:" align:#left offset:[0,-5]
		)
		multiListBox mlAvailableElements "" width:293 height:20  offset:[-10,0]-- height is measured in Lines, not pixels
		button bContinue "Continue" across:2
		button bCancel "Cancel" 
		
		-- prepare the class list
		on missingMapCoordsRO open do
		(
			for obj in gTextureBakeDialog.missingDataList do
				append itemList ("(UVW " + obj.INodeBakeProperties.bakeChannel as string + "): " + obj.name)
			mlAvailableElements.items = itemList 
		)
		
		on missingMapCoordsRO close do
		(
			pMissingMapCoordsPos = GetDialogPos missingMapCoordsRO
			gTextureBakeDialog.missingDataList = undefined
		)
		
		-- Continue handler
		on bContinue pressed do
		(
			-- set flag in gTextureBakeDialog to continue
			gTextureBakeDialog.cancelRender = false
			-- and destroy the dialog
			destroydialog missingMapCoordsRO 
		)
		-- Cancel handler
		on bCancel pressed do
		(
			-- set flag in gTextureBakeDialog to cancel
			gTextureBakeDialog.cancelRender = true
			-- and destroy the dialog
			destroydialog missingMapCoordsRO 
		)
	)
	
	if _debug do format "in MapCoordsOK : %\n" _ObjectList
	
	gTextureBakeDialog.missingDataList = #()
	for obj_i in _ObjectList do
	(
		local obj = obj_i.node
		local bakeInterface = obj.INodeBakeProperties
		if _debug do format "MapCoordsOK test: % : % : %\n" obj (bakeInterface.effectiveEnable()) (ObjHasMapConflicts obj)
		if (bakeInterface.effectiveEnable()) and not (ObjHasMapConflicts obj) then
		(	if not obj_i.channels[bakeInterface.bakeChannel] do
				append gTextureBakeDialog.missingDataList obj
		)
	)
	
	gTextureBakeDialog.cancelRender = false
	if gTextureBakeDialog.missingDataList.count != 0 do
	(	
		createDialog missingMapCoordsRO modal:true pos:pMissingMapCoordsPos 
	)
	
	return (not gTextureBakeDialog.cancelRender)
) -- end - function MapCoordsOK

-- function to check to make sure Target Map Slot Names are specified for each element
-- returns true if ok to render, false if not
--
function MapTargetsOK _ObjectList =
(
	rollout missingMapTargetsRO "Missing Map Targets" width:300
	(
		local itemList = #()
		group ""
		(	label lbl1 "The following elements do not specify a Target Map slot:" align:#left offset:[0,-10]
		)
		multiListBox mlAvailableElements "" width:293 height:20  offset:[-10,0]-- height is measured in Lines, not pixels
		button bContinue "Continue" across:2
		button bCancel "Cancel" 
		
		-- prepare the class list
		on missingMapTargetsRO open do
		(
			for ele in gTextureBakeDialog.missingDataList do
				append itemList (ele.node.name + ": " + ele.element.elementName)
			mlAvailableElements.items = itemList 
		)
		
		on missingMapTargetsRO close do
		(
			pMissingMapTargetsPos = GetDialogPos missingMapTargetsRO 
			gTextureBakeDialog.missingDataList = undefined
		)
		
		-- Continue handler
		on bContinue pressed do
		(
			-- set flag in gTextureBakeDialog to continue
			gTextureBakeDialog.cancelRender = false
			-- and destroy the dialog
			destroydialog missingMapTargetsRO 
		)
		-- Cancel handler
		on bCancel pressed do
		(
			-- set flag in gTextureBakeDialog to cancel
			gTextureBakeDialog.cancelRender = true
			-- and destroy the dialog
			destroydialog missingMapTargetsRO 
		)
	)
	
	if _debug do format "in MapTargetsOK : %\n" _ObjectList
	
	gTextureBakeDialog.missingDataList = #()
	for obj_i in _ObjectList do
	(
		local obj = obj_i.node
		local bakeInterface = obj.INodeBakeProperties
		if (bakeInterface.effectiveEnable()) and not (ObjHasMapConflicts obj) then
		(	
			local nElements = bakeInterface.NumBakeElements()
			for i = 1 to nElements do
			(
				local myElement = bakeInterface.GetBakeElement i 
				if myElement.enabled and (myElement.targetMapSlotName == "" or myElement.targetMapSlotName == " ") do
					append gTextureBakeDialog.missingDataList (bakeElementStruct myElement obj)
			)
		)
	)
	
	if gTextureBakeDialog.missingDataList.count != 0 do
	(	
		createDialog missingMapTargetsRO modal:true pos:pMissingMapTargetsPos
	)
	
	return (not gTextureBakeDialog.cancelRender)
) -- end - function MapTargetsOK

-- function to check to make sure there are no missing map files
-- returns true if ok to render, false if not
--
function MapFilesOK _ObjectList =
(
	rollout missingMapFilesRO "Missing Map Files" width:500
	(
		local itemList = #()
		group ""
		(	label lbl1 "The following nodes are missing map files and may not render correctly:" align:#left offset:[0,-10]
		)
		multiListBox mlAvailableElements "" width:493 height:20  offset:[-10,0]-- height is measured in Lines, not pixels
		button bContinue "Continue" across:2
		button bCancel "Cancel" 
		
		-- prepare the class list
		on missingMapFilesRO open do
		(
			for ele in gTextureBakeDialog.missingDataList do
			(
				append itemList (ele[1].name + ": ")
				local maps = ele[2]
				for m in maps do
					append itemList ("   "+m)
			)
			mlAvailableElements.items = itemList 
		)
		
		on missingMapFilesRO close do
		(
			pMissingMapFilesPos = GetDialogPos missingMapFilesRO
			gTextureBakeDialog.missingDataList = undefined
		)
		
		-- Continue handler
		on bContinue pressed do
		(
			-- set flag in gTextureBakeDialog to continue
			gTextureBakeDialog.cancelRender = false
			-- and destroy the dialog
			destroydialog missingMapFilesRO
		)
		-- Cancel handler
		on bCancel pressed do
		(
			-- set flag in gTextureBakeDialog to cancel
			gTextureBakeDialog.cancelRender = true
			-- and destroy the dialog
			destroydialog missingMapFilesRO
		)
	)
	
	if _debug do format "in MapFilesOK : %\n" _ObjectList
	
	local missingMapsForNodes = #()
	for obj in _ObjectList do
	(
		local missingMaps=#()
		function addmap mapfile missingMaps = 
		(
			local found = false
			for m in missingMaps while not found do
				if (stricmp m mapfile) == 0 do found = true
			if not found do append missingMaps mapfile
		)

		-- force render to use original material for baking
		local saveRenderMtlIndex = -1
		local materialType = classof obj.material
		if (materialType == Shell_Material) then
		(
			saveRenderMtlIndex = obj.material.renderMtlIndex
			with undo off obj.material.renderMtlIndex = 0
		)

		enumerateFiles obj addmap missingMaps #missing #render
		
		if saveRenderMtlIndex != -1 do
			with undo off obj.material.renderMtlIndex = saveRenderMtlIndex
		
		if missingMaps.count != 0 do
		(
			sort missingMaps
			append missingMapsForNodes #(obj,missingMaps)
		)
	)
	gTextureBakeDialog.missingDataList = missingMapsForNodes
	
	gTextureBakeDialog.cancelRender = false
	if missingMapsForNodes.count != 0 do
	(	
		createDialog missingMapFilesRO modal:true pos:pMissingMapFilesPos 
	)
	
	return (not gTextureBakeDialog.cancelRender)
) -- end - function MapFilesOK

function OutputDirsOK _ObjectList =
(
	rollout invalidOutDirRO "Invalid Output Directories" width:500
	(
		local itemList = #()
		group ""
		(	label lbl1 "The following nodes output to invalid directories and will not be rendered:" align:#left offset:[0,-10]
		)
		multiListBox mlAvailableElements "" width:493 height:20  offset:[-10,0]-- height is measured in Lines, not pixels
		button bContinue "Continue" across:2
		button bCancel "Cancel" 
		
		-- prepare the class list
		on invalidOutDirRO open do
		(
			for ele in gTextureBakeDialog.missingDataList do
			(
				append itemList (ele[1].name + ": ")
				local maps = ele[2]
				for m in maps do
					append itemList ("   "+m)
			)
			mlAvailableElements.items = itemList 
		)
		
		on invalidOutDirRO close do
		(
			pInvalidOutDirPos = GetDialogPos invalidOutDirRO 
			gTextureBakeDialog.missingDataList = undefined
		)
		
		-- Continue handler
		on bContinue pressed do
		(
			-- set flag in gTextureBakeDialog to continue
			gTextureBakeDialog.cancelRender = false
			-- and destroy the dialog
			destroydialog invalidOutDirRO
		)
		-- Cancel handler
		on bCancel pressed do
		(
			-- set flag in gTextureBakeDialog to cancel
			gTextureBakeDialog.cancelRender = true
			-- and destroy the dialog
			destroydialog invalidOutDirRO
		)
	)
	
	if _debug do format "in OutputDirsOK: %\n" _ObjectList
	
	local invalidOutDirForNodes = #()
	local defaultPath = commonBakeProps.GetFilePath()
	
	pushprompt "validating and creating output directories"
	
	for obj in _ObjectList do
	(
		local invalidOutDir=#()
		function addDir missingDirs dir = 
		(
			local found = false
			for m in missingDirs while not found do
				if (stricmp m dir) == 0 do found = true
			if not found do append missingDirs dir
		)

		RTT_methods.UpdateBitmapFilenames obj "" defaultPath defaultFileType 

		local bakeInterface = obj.INodeBakeProperties
		local nElements = bakeInterface.numBakeElements()
		for i = 1 to nElements do
		(
			-- get the element
			local ele = bakeInterface.getBakeElement i
			
			if ele.enabled do
			(
				-- see if the directory exists or can be created
				local theDir = getFilenamePath ele.fileType
				local res = RTT_methods.ValidateDirectory theDir
				if not res do addDir invalidOutDir theDir 
			)
		) -- end, for each element

		if invalidOutDir.count != 0 do
			append invalidOutDirForNodes #(obj,invalidOutDir)
	)
	gTextureBakeDialog.missingDataList = invalidOutDirForNodes 

	popprompt()
	
	gTextureBakeDialog.cancelRender = false
	if invalidOutDirForNodes.count != 0 do
	(	
		createDialog invalidOutDirRO modal:true pos:pInvalidOutDirPos 
		
		if (not gTextureBakeDialog.cancelRender) do
			for ele in invalidOutDirForNodes do
				deleteItem _ObjectList (findItem _ObjectList ele[1])
	)
	 
	return (not gTextureBakeDialog.cancelRender)
) -- end - function OutputDirsOK 


------------------------------------------------------------------
--
--	Function to ensure that the set of objects have unique names
--
function NodeNamesOK _ObjectList =
(
	local res = true
	local nodeNames = #()
	local noDupes = true
	for o in _ObjectList do
	(
		if noDupes do noDupes = (findItem nodeNames o.name) == 0
		append nodeNames o.name
	)
	if _debug2 do format "in NodeNamesOK: %\n" nodeNames 
	if _debug2 do format "in NodeNamesOK: %\n" noDupes
	
	if not noDupes do
	(
		local duplicateNodeNameErrorText = "Duplicate node names exist for the nodes to bake.\r"+
			"This will result in multiple nodes writing to the same bitmap output files, giving incorrect results.\r\r"+
			"Permanently rename nodes to make unique (Yes), render with current names (No),\r"+
			"or cancel render (Cancel)?"
		res = yesNoCancelBox duplicateNodeNameErrorText  title:"Rename Duplicate Node Names?"
		
		if res == #Cancel then
			res = false
		else if res == #yes then
		(
			for i = 1 to _ObjectList.count do
			(
				nodeNames[i] = &undefined
				local k
				while ((k = findItem nodeNames _ObjectList[i].name) != 0) do
					_ObjectList[k].name = nodeNames[k] = uniqueName (_ObjectList[k].name+"_")
			)
--			selectedObjectProps.RefreshObjectsLV workingObjectsOnly:true updateNodeNames:true 
			res = true
		)
		else
			res = true
	)
	res
) -- end - function NodeNamesOK 

------------------------------------------------------------------
--
--	Function to bake a set of textures on each of a set of objects
--
function BatchBake _ObjectList = 
(
	undo "Bake Objects" on 
	(
		if _debug do format "bake % objects; selection count: % : %\n"  _ObjectList.count selectedObjects.count selection.count
		
	    -- commit the render scene dialog if it's still up		
		renderSceneDialog.commit()
		
		-- select the settings to use
--		renderer = if (commonBakeProps.rDraftOrProduction.state == 1) then #production else #draft
		
		if not renderers.current.supportsTexureBaking do
		(	
			messageBox "Current renderer does not support texture baking"
			return 0
		)
		
		local renderFrameList = RTT_methods.GetRenderFrames()
		if renderFrameList.count == 0 do return 0
		
		local vfbOn = commonBakeProps.cDisplayFB.checked
		local defaultPath = commonBakeProps.GetFilePath()
		
		-- collect nodes we will actually render
		local nodesToRender = #()
		for i = 1 to _ObjectList.count do
		(
			local obj = _ObjectList[i].node
			local w = obj.renderWidth()
			local h = obj.renderHeight()
			if (not obj.INodeBakeProperties.effectiveEnable()) or (ObjHasMapConflicts obj) or w <= 0 or h <= 0 then
				if _debug do format "skipping: %: % % : % %\n" obj.name (obj.effectiveEnable()) (ObjHasMapConflicts obj) w h
			else
				append nodesToRender obj 
		)
		if nodesToRender.count == 0 do return 0
		
		-- check for missing maps
		if not (MapFilesOK nodesToRender) do return 0
		
		-- check for bad output directories
		if not (OutputDirsOK nodesToRender) do return 0
		
		-- check for duplicate node names
		if not (NodeNamesOK nodesToRender) do return 0
		
		local cached_RadiosityPreferences_computeRadiosity = undefined
		
		if ( not bakedMtlProps.cbRenderToFilesOnly.checked ) then
		(
			local mtl
			for n in nodesToRender where (mtl = n.material) != undefined do
			(
				setAppData mtl RTT_MtlName_AppData_Index mtl.name
				setAppData mtl (RTT_MtlName_AppData_Index+1) "N"
			)
		)

		with redraw off 
		(
			local numFrames = renderFrameList.count
				
			-- create the bake progress dialog
			local progressScale = 100. / (nodesToRender.count * numFrames)
			if _debug do format "\tprogressScale: %; numFrames: %\n" progressScale numFrames 
		
			rollout bakeProgress "Progress..." width:183 height:48
			(
				label lbl1 "Baking Textures..." pos:[48,6] width:94 height:21
				progressBar pb1 "" pos:[5,22] width:174 height:17
			)
			-- & put it up
			createdialog bakeProgress  pos:((sysinfo.DesktopSize/2)-[100,250]) -- style:#(#style_border,#style_toolwindow)
			bakeProgress.pb1.value = 0 
			
			-- bake each object in turn
			for i = 1 to nodesToRender.count do
			(
				local obj = nodesToRender[i]
				
				-- bake the object
				local w = obj.renderWidth()
				local h = obj.renderHeight()
				if _debug do format "    bake object % to % x % \n" (obj.name) w h
				
				if (curBM == undefined) or (curBM.width != w ) or (curBM.height != h) then
				(	
					-- create new bm
					if curBM != undefined then 
						close curBM -- close the VFB and free bitmap's memory
					curBM = bitmap w h
				)
				
				updateFileNames = #() -- stores element output file name for each frame
				
				local restoreToGroup = false
				if isGroupMember obj then
				(
					setGroupMember obj false
					restoreToGroup = true
				)
				
				local saveRenderMtlIndex = -1
				with undo off 
				(
					--  select the object
					select obj
					
					-- force render to use original material for baking
					local materialType = classof obj.material
					if (materialType == Shell_Material and obj.material.renderMtlIndex != 0) then
					(
						saveRenderMtlIndex = obj.material.renderMtlIndex
						obj.material.renderMtlIndex = 0
					)
				)
		
				-- for each frame
				local frameCount = 0
				for nFrame in renderFrameList do
				(
					frameCount += 1
					-- update the bitmap names
					local n = if (rendTimeType == 2) or (rendTimeType == 3) then 
								(nFrame + rendFileNumberBase) 
							  else nFrame
					RTT_methods.UpdateBitmapFilenames obj n defaultPath defaultFileType 
					
					-- update the progress bar
					bakeProgress.pb1.value = progressScale * ( ((i-1) * numFrames) + frameCount - 1 )
					if _debug do format "\trender status: % : % : % : % : % : %\n" bakeProgress.pb1.value progressScale i numFrames nFrame frameCount 

					local skipRender = false
					if (commonBakeProps.cSkipExistingFiles.checked) then
					(	
						if (RTT_methods.CheckAllBakeElementOutputFilesExist obj) do skipRender = true
					)
					else
					(
						-- check if the files already exist
						if not (CheckFileOverwrite obj) then
						(
							-- don't overwrite files, boot
							--format "can't overwrite files\n"
							destroydialog bakeProgress 
		
							if	restoreToGroup do
								setGroupMember obj true
							with undo off 
							(
								if saveRenderMtlIndex >= 0 do
									obj.material.renderMtlIndex = saveRenderMtlIndex 
								if selectedObjects.count != 0 then select selectedObjects else clearSelection()	-- reselect
							)
							
							if (cached_RadiosityPreferences_computeRadiosity != undefined) do
								RadiosityPreferences.computeRadiosity = cached_RadiosityPreferences_computeRadiosity

							return 0	-- cancel
						)
					)
				
					-- render the texture elements
					if _debug do format "\trender frame % \n" nFrame
					local wasCanceled = false
					local oldsilentmode = setSilentMode true
					
					try
					(
						if (not skipRender) do 
						(
							render rendertype:#bakeSelected frame:nFrame to:curBM vfb:vfbOn cancelled:&wasCanceled
							if (cached_RadiosityPreferences_computeRadiosity == undefined) do
							(
								cached_RadiosityPreferences_computeRadiosity = RadiosityPreferences.computeRadiosity
								RadiosityPreferences.computeRadiosity = false
							)
						)
						setSilentMode oldsilentmode 
					)
					catch
					(
						destroydialog bakeProgress 
	
						if	restoreToGroup do
							setGroupMember obj true
						with undo off 
						(
							if saveRenderMtlIndex >= 0 do
								obj.material.renderMtlIndex = saveRenderMtlIndex 
							if selectedObjects.count != 0 then select selectedObjects else clearSelection()	-- reselect
						)
						setSilentMode oldsilentmode 
						messageBox "System exception occurred during render"

						if (cached_RadiosityPreferences_computeRadiosity != undefined) do
							RadiosityPreferences.computeRadiosity = cached_RadiosityPreferences_computeRadiosity

						return 0	-- cancel
					)
				
					if (  wasCanceled ) then
					(
						destroydialog bakeProgress 
	
						if	restoreToGroup do
							setGroupMember obj true
						with undo off 
						(
							if saveRenderMtlIndex >= 0 do
								obj.material.renderMtlIndex = saveRenderMtlIndex 
							if selectedObjects.count != 0 then select selectedObjects else clearSelection()	-- reselect
						)
						setSilentMode oldsilentmode 
						messageBox "Render Failed or Cancelled by User"

						if (cached_RadiosityPreferences_computeRadiosity != undefined) do
							RadiosityPreferences.computeRadiosity = cached_RadiosityPreferences_computeRadiosity

						return 0	-- cancel
					)
					
					--format "collect files for frame = %\n" nFrame
					CollectUpdateFiles obj

					if _trackMemory do
					(	r1 = sysinfo.getMAXMemoryInfo()
						r2 = sysinfo.getSystemMemoryInfo()
						format "% : % : % : %\n" obj.name nFrame r1 r2
					)
				
				) -- end, for each frame
				
				-- restore object to the group
				if	restoreToGroup do
					setGroupMember obj true
					
				-- prepare baked materials?
				ApplyUpdateFiles obj
				if ( not bakedMtlProps.cbRenderToFilesOnly.checked ) then
				(
					UpdateMaterial obj
					updateFileNames = undefined
				) -- end, shell materials enabled
		
				with undo off 
				(
					if saveRenderMtlIndex >= 0 do
						obj.material.renderMtlIndex = saveRenderMtlIndex 
				)
		
				if _debug do format "end of bake object\n"
		
			) -- end, for each object
			
			-- toss the progress dialog
			destroydialog bakeProgress
			
			-- reselect
			with undo off if selectedObjects.count != 0 then select selectedObjects else clearSelection()
		
			if (cached_RadiosityPreferences_computeRadiosity != undefined) do
				RadiosityPreferences.computeRadiosity = cached_RadiosityPreferences_computeRadiosity

			if ( not bakedMtlProps.cbRenderToFilesOnly.checked ) then
			(
				local mtl
				for n in nodesToRender where (mtl = n.material) != undefined do
				(
					deleteAppData mtl RTT_MtlName_AppData_Index
					deleteAppData mtl (RTT_MtlName_AppData_Index+1)
				)
			)

		) -- end, with redraw off

	) -- end, undo "Batch Bake"	

	if _debug do format "bake exit; selection count: % : %\n"  selectedObjects.count selection.count
) -- end, function BatchBake 

------------------------------------------------------------------
--
--	Function to send a set of objects to the net renderer for baking
--
function NetBatchBake _ObjectList = 
(
	if _debug do format "net bake % objects; selection count: % : %\n"  _ObjectList.count selectedObjects.count selection.count
	
    -- commit the render scene dialog if it's still up		
	renderSceneDialog.commit()
	
	-- select the settings to use
--	renderer = if (commonBakeProps.rDraftOrProduction.state == 1) then #production else #draft
	
	-- cache the renderer's skip render frames and Show VFB settings. We will replace them with the local setting
	local old_skipRenderedFrames = skipRenderedFrames 
	local old_rendShowVFB = rendShowVFB
	
	-- collect nodes we will actually render
	local nodesToRender = #()
	for i = 1 to _ObjectList.count do
	(
		local obj = _ObjectList[i].node
		local w = obj.renderWidth()
		local h = obj.renderHeight()
		if (not obj.INodeBakeProperties.effectiveEnable()) or (ObjHasMapConflicts obj) or w <= 0 or h <= 0 then
			if _debug do format "skipping: %: % % : % %\n" obj.name (obj.effectiveEnable()) (ObjHasMapConflicts obj) w h
		else
			append nodesToRender obj 
	)
	if nodesToRender.count == 0 do return 0
	
	-- check for missing maps
	if not (MapFilesOK nodesToRender) do return 0
	
	-- check for duplicate node names
	if not (NodeNamesOK nodesToRender) do return 0

	if nodesToRender.count != 0 do
	(
		skipRenderedFrames = commonBakeProps.cSkipExistingFiles.checked
		rendShowVFB = commonBakeProps.cDisplayFB.checked
		fileproperties.addproperty #custom "RTT_Default_Path" (commonBakeProps.GetFilePath())
		fileproperties.addproperty #custom "RTT_Default_FileType" defaultFileType 
		fileproperties.addproperty #custom "RTT_RenderTimeType" rendTimeType
		
		local res = NetworkRTT nodesToRender
		--local res = netrender.RenderToTexture nodesToRender
		if not res do messagebox "net render submission failed"

		fileproperties.deleteproperty #custom "RTT_Default_Path" 
		fileproperties.deleteproperty #custom "RTT_Default_FileType"
		fileproperties.deleteproperty #custom "RTT_RenderTimeType"
		skipRenderedFrames = old_skipRenderedFrames
		rendShowVFB = old_rendShowVFB
	)
			
	if _debug do format "net bake exit; selection count: % : %\n"  selectedObjects.count selection.count
) -- end, function NetBatchBake 

------------------------------------------------------------------
--
--	Function to update the baked materials on each of a set of objects. 
--  Same as a bake without doing the actual rendering
--
function UpdateBakedMtls _ObjectList = 
(
	undo "Update Baked Mtls" on 
	(
		if _debug do format "Update Baked Mtls - % objects\n"  _ObjectList.count
		
	    -- commit the render scene dialog if it's still up		
		renderSceneDialog.commit()
		
		local renderFrameList = RTT_methods.GetRenderFrames()
		local numFrames = renderFrameList.count
		if numFrames == 0 do return 0

		local defaultPath = commonBakeProps.GetFilePath()

		for i = 1 to _ObjectList.count do
		(
			local mtl = _ObjectList[i].node.material
			if mtl != undefined do
			(
				setAppData mtl RTT_MtlName_AppData_Index mtl.name
				setAppData mtl (RTT_MtlName_AppData_Index+1) "N"
			)
		)

		-- pseudo-bake each object in turn
		for i = 1 to _ObjectList.count do
		(
			local obj = _ObjectList[i].node
			local w = obj.renderWidth()
			local h = obj.renderHeight()
			
			if (obj.INodeBakeProperties.effectiveEnable() and (not (ObjHasMapConflicts obj)) and w > 0 and h > 0) then
			(
				updateFileNames = #() -- stores element output file name for each frame
				-- update the bitmap names and the material
				if _debug do format "update bake mtl on object: %\n" obj.name
				for nFrame in renderFrameList do
				(
					-- find the frame number for the bitmap file
					local n = if (rendTimeType == 2) or (rendTimeType == 3) then 
								(nFrame + rendFileNumberBase) 
							  else nFrame
				
					RTT_methods.UpdateBitmapFilenames obj n defaultPath defaultFileType 
					CollectUpdateFiles obj
				)
				
				ApplyUpdateFiles obj
				UpdateMaterial obj
				if _debug do format "end of update bake mtl on object\n"
			)
			else
			(
				if _debug do format "skipping: %\n" obj.name
			)
			
		) -- end, for each object
		
		for i = 1 to _ObjectList.count do
		(
			local mtl = _ObjectList[i].node.material
			if mtl != undefined do
			(
				deleteAppData mtl RTT_MtlName_AppData_Index
				deleteAppData mtl (RTT_MtlName_AppData_Index+1)
			)
		)
		
	) -- end, undo "Batch Bake"	
	if _debug do format "Update Baked Mtls exit\n"
) -- end, function UpdateBakedMtls 

------------------------------------------------------------------
--
--	Function to return array of elements that are common to all the input arrays
--
function CollectCommonElements arrayList =
(
	local res = #()
	if arrayList.count == 1 then -- just return first array
		res = arrayList[1]
	else if arrayList.count > 1 do -- initialize with copy of first array
		res = copy arrayList[1] #nomap
	for i = 2 to arrayList.count while res.count != 0 do
	(
		local theArray = arrayList[i]
		for j = res.count to 1 by -1 do  -- for each element remaining in output list
		(	local index = findItem theArray res[j] -- see if it exists in input array
			if index == 0 do deleteItem res j -- if not, remove from output list
		)
	)
	return res
) -- end - function CollectCommonElements

-- function returns array of the non-blank texmap slot names for material
function GetTexmapSlotNamesOfMtl mtl =
(	local nmaps = getNumSubTexmaps mtl
	local res = #()
	for i = 1 to nmaps do 
	(	
		local sname = getSubTexmapSlotName mtl i
		if sname.count != 0 do
			append res sname
	)
	return res
) -- end - function GetTexmapSlotNamesOfMtl 

-- function to collect available target map names for material. 
-- If mtl has no subMaterials, return texmap slot names
-- If mtl has subMaterials, return texmap slot names present for all existing subMaterials
-- plus the mtl's texmap slot names.
-- if mtl or submtl is a Shell material, process the mtl in Original Material slot instead
-- of the Shell material
-- only walk one subMaterial level down.
function CollectTargetMapNamesForMtl mtl =
(	
	local res
	if classof mtl == Shell_Material do
		mtl = mtl.originalMaterial
	local nmtls = getNumSubMtls mtl
	if (nmtls != 0) then
	(	
		local subRes = #()
		for i = 1 to nmtls do
		(	smtl = getSubMtl mtl i
			if classof smtl == Shell_Material do
				smtl = smtl.originalMaterial
			if smtl != undefined do
				append subRes (GetTexmapSlotNamesOfMtl smtl)
		)
		res = CollectCommonElements subRes
	)
	else
		res = #()
	join res (GetTexmapSlotNamesOfMtl mtl)
	return res
) -- end - function CollectTargetMapNamesForMtl

-- function to collect common available target map names for a node's material. 
function CollectTargetMapNamesForNode theNode =
(
	local res =
		if ((bakedMtlProps.rbDestination.state == 1) or (bakedMtlProps.rbShellOption.state == 1)) then
		(
			if theNode.material != undefined then
		   		CollectTargetMapNamesForMtl theNode.material
			else
				newNodeMtlTargetMapNames
		)
		else 
		(
			newBakedMtlTargetMapNames 
		)
--	if _debug do format "CollectTargetMapNamesForNode: % : %\n" theNode res
	return res
) -- end - function CollectTargetMapNamesForNode

--	Function to return array of material names and instances that can be used as a RTT target mtl
function CollectMtlTypes =
(
	local mtlInstance
	local mtllist = #()
	-- collect flavors of standard material
	for i = 0 to 7 do 
	(	mtlInstance = standard shaderType:i
		append mtllist (RTT_MlTypes (standard as string + ":" + mtlInstance.shaderByName) mtlInstance)
	)
	-- collect creatable materials other than standard, shell, DX9
	for mtl in material.classes where mtl.creatable and mtl != standard and mtl != Shell_Material and mtl != DirectX_9_Shader do
	(
		try
		(	
			mtlInstance = mtl()
			if mtlInstance != undefined do
				append mtllist (RTT_MlTypes (mtl as string) mtlInstance)
		)
		catch ()
	)
	-- look for .fx files in the map directories and, if it exists, the fx directory in each of those directories
	-- the map directories
	local nMapPaths = mapPaths.count()
	local mapPathDirs = for i = 1 to nMapPaths collect (mapPaths.get i)
	if _debug do format "% : %\n" nMapPaths mapPathDirs 
	-- the fx subdirectories. Add only if not already present
	for i = 1 to nMapPaths do 
	(
		local tPath = mapPathDirs[i]+"/fx"
		if findItem mapPathDirs tPath == 0 do append mapPathDirs tPath 
	)
	for mapPath in mapPathDirs do
	(
		local fxFiles = getFiles (mapPath+"/*.fx")
		for fxFile in fxFiles do
		(
--			try
			(
				mtlInstance = DirectX_9_Shader effectFile:fxFile
				append mtllist (RTT_MlTypes (DirectX_9_Shader as string + ":" + (getFilenameFile fxFile)) mtlInstance)
			)
--			catch()
		)
	)
	mtllist
)

------------------------------------------------------------------
--
-- function for setting the default map slot name for combination of material and bake element to the ini file
-- if the default mapping doesn't already exist in the ini file
-- argument is a bakeElementStruct instance
--
function UpdateDefaultMtlMapSlotMapping ele =
(
	if _debug do format "UpdateDefaultMtlMapSlotMapping ele: %\n" ele
	local theMtl =	if ((bakedMtlProps.rbDestination.state == 1) or (bakedMtlProps.rbShellOption.state == 1)) then
					(
						local tmpMtl = ele.node.material
						if classof tmpMtl == Shell_Material do tmpMtl = tmpMtl.originalMaterial
						if tmpMtl != undefined then
					   		tmpMtl 
						else
							newNodeMtlInstance
					)
					else 
						newBakedMtlInstance
	local theMtlClass = classof theMtl
	local keyName = theMtlClass as string
	if theMtlClass == StandardMaterial then
		append keyName (":"+theMtl.shaderByName)
	else if theMtlClass == DirectX_9_Shader then
		append keyName (":"+getFilenameFile theMtl.effectFile)
	keyName = RTT_methods.MakeFileNameValid keyName 
	local sectionName = RTT_methods.MakeFileNameValid ((classof ele.element) as string)
	local targetMapSlot = ele.element.targetMapSlotName
	if _debug do format "\t% % '%' '%'\n" keyName sectionName targetMapSlot (getIniSetting iniFile keyName sectionName)
	if (getIniSetting iniFile keyName sectionName) == "" do
		setIniSetting iniFile keyName sectionName targetMapSlot 
)

------------------------------------------------------------------
--
-- function for getting the default map slot name for combination of material and bake element from the ini file
-- argument is a bakeElementStruct instance
--
function GetDefaultMtlMapSlotMapping ele =
(
	if _debug do format "GetDefaultMtlMapSlotMapping ele: %\n" ele
	local theMtl =	if ((bakedMtlProps.rbDestination.state == 1) or (bakedMtlProps.rbShellOption.state == 1)) then
					(
						local tmpMtl = ele.node.material
						if classof tmpMtl == Shell_Material do tmpMtl = tmpMtl.originalMaterial
						if tmpMtl != undefined then
					   		tmpMtl 
						else
							newNodeMtlInstance
					)
					else 
						newBakedMtlInstance
	local theMtlClass = classof theMtl
	local keyName = theMtlClass as string
	if theMtlClass == StandardMaterial then
		append keyName (":"+theMtl.shaderByName)
	else if theMtlClass == DirectX_9_Shader then
		append keyName (":"+getFilenameFile theMtl.effectFile)
	keyName = RTT_methods.MakeFileNameValid keyName 
	local sectionName = RTT_methods.MakeFileNameValid ((classof ele.element) as string)
	if _debug do format "\t% % '%'\n" keyName sectionName (getIniSetting iniFile keyName sectionName)
	getIniSetting iniFile keyName sectionName
)


------------------------------------------------------------------
--
-- function for building a list of render presets. Pulled from current ini file [RenderPresetsMruFiles] section.
function LoadRenderPresetList =
(	
	renderPresetFiles = #() 
	-- get key names for [RenderPresetsMruFiles] section 
	local keys = getinisetting (GetMAXIniFile()) "RenderPresetsMruFiles"
	for k in keys do
	(
		local filename = getinisetting (GetMAXIniFile()) "RenderPresetsMruFiles" k
		if filename != "" and (doesFileExist filename) do
			append renderPresetFiles filename
	)
	renderPresetFiles
)

------------------------------------------------------------------
--
--	utility functions for reading/writing .ini files
--
function GetINIConfigData filename section key default =
(
	local res = getINISetting filename section key
	if res == "" then default
	else readValue (stringStream res)
) -- end - function GetINIConfigData

function SetINIConfigData filename section key value =
(
	setINISetting filename section key (value as string)
) -- end - function SetINIConfigData

-- Functions for reading/writing dialog info to .ini file
function ReadDialogConfig =
(
	pDialogHeight = GetINIConfigData iniFile "Dialog" "DialogHeight " 526
	pDialogPos = GetINIConfigData iniFile "Dialog" "DialogPos" [120,100]
	pFileOverwriteBoxPos = GetINIConfigData iniFile "FileOverwriteBox" "Pos" [-1,-1]
	pMissingMapCoordsPos = GetINIConfigData iniFile "MissingMapCoords" "Pos" [-1,-1]
	pMissingMapTargetsPos = GetINIConfigData iniFile "MissingMapTargets" "Pos" [-1,-1]
	pMissingMapFilesPos = GetINIConfigData iniFile "MissingMapFiles" "Pos" [-1,-1]
	pAddElementsPos = GetINIConfigData iniFile "AddElements" "Pos" [-1,-1]
	pInvalidOutDirPos = GetINIConfigData iniFile "InvalidOutputDirs" "Pos" [-1,-1]
	
) -- end - function ReadDialogConfig

function WriteDialogConfig =
(
	--format "write dialog height = % \n" pDialogHeight
	SetINIConfigData iniFile "Dialog" "DialogHeight" pDialogHeight
	SetINIConfigData iniFile "Dialog" "DialogPos" pDialogPos
	SetINIConfigData iniFile "FileOverwriteBox" "Pos" pFileOverwriteBoxPos
	SetINIConfigData iniFile "MissingMapCoords" "Pos" pMissingMapCoordsPos
	SetINIConfigData iniFile "MissingMapTargets" "Pos" pMissingMapTargetsPos
	SetINIConfigData iniFile "MissingMapFiles" "Pos" pMissingMapFilesPos
	SetINIConfigData iniFile "AddElements" "Pos" pAddElementsPos
	SetINIConfigData iniFile "InvalidOutputDirs" "Pos" pInvalidOutDirPos

	RTT_Data.Dialog_CommonBakeProps_Open = commonBakeProps.open
	RTT_Data.Dialog_SelectedObjectProps_Open = selectedObjectProps.open
	RTT_Data.Dialog_SelectedElementProps_Open = selectedElementProps.open
	RTT_Data.Dialog_BakedMtlProps_Open = bakedMtlProps.open
	
) -- end - function WriteDialogConfig

------------------------------------------------------------------
--
--	ListView utility functions 
--

-- Function to initialize a single selection ListView with some preset states and values
function InitListView lv numCols colNames colWidths hideHeaders:true checkBoxes:true =
(
	lv.gridLines = true
	lv.checkBoxes = checkBoxes
	lv.borderStyle = #ccFixedSingle
	lv.view = #lvwReport
	lv.fullRowSelect = true
	lv.multiSelect = false
	lv.labelEdit = #lvwManual
	lv.hideSelection = false
	lv.sorted = false
	lv.allowColumnReorder = false
 
	-- Add columns and name them 
	for i = 1 to numCols do
	(
		local header = lv.ColumnHeaders.add()
		header.text = colNames[i]
	)
	
	-- Set the size of the columns
	local LVM_FIRST = 0x1000, LVM_SETCOLUMNWIDTH = (LVM_FIRST + 30)
	for i = 1 to numCols do
		windows.sendMessage lv.hwnd LVM_SETCOLUMNWIDTH  (i-1) colWidths[i]

	-- Hide the column headers if needed
	lv.hideColumnHeaders = hideHeaders
	
	-- Set Listview to System Colors
	textColor = ((colorman.getColor #text)*255) as color
	windowColor = ((colorman.getColor #window)*255) as color
	
	lv.backColor = (color windowColor.b windowColor.g windowColor.r) -- this is he BGR thing...
	lv.foreColor = (color textColor.b textColor.g textColor.r)
) -- end - function InitListView 

function GetLvSelection lv =
(
	local res 
	if lv.multiSelect then
	(
		res = #{}
		for i in 1 to lv.listItems.count do
			if lv.listItems[i].selected do 
				res[i]= true
	)
	else
	(
		res = 0
		for i in 1 to lv.listItems.count while (res == 0) do
			if lv.listItems[i].selected do 
				res = i
	)
	return res
) -- end - function GetLvSelection 

function SelectLvItem lv nItem =
(
	if( nItem != undefined ) and ( nItem > 0 ) then
	(
		if( nItem > lv.listItems.count) then
			nItem = lv.listItems.count	-- off the end, use last item

		li = lv.listItems[ nItem ]
		if li != undefined then
			li.selected = true
	)
	else (
		-- item 0 .... unselect all
		for li in lv.listItems do
			li.selected = false
	)
) -- end - function SelectLvItem 

function GetLvItemName lv nItem column =
(
	local res
	if nItem > 0 and nItem <= lv.listItems.count and column > 0 then
	(	local li = lv.listItems[ nItem ]
		if column == 1 then
			res = li.text
		else
		(	column -= 1
			local si = li.ListSubItems
			if column <= si.count then
				res = si[column].text
			else
				res = ""
		)
	)
	else 
		res = ""
	
	return res
) -- end - function GetLvItemName 

function SetLvItemName lv nItem column newName =
(
	if nItem > 0 and nItem <= lv.listItems.count and column > 0 then
	(	local li = lv.listItems[ nItem ]
		if column == 1 then
			li.text = newName as string
		else
		(	column -= 1
			local si = li.ListSubItems
			if column <= si.count do
				si[column].text = newName as string
		)
	)
) -- end - function SetLvItemName 

function GetLvItemCheck lv nItem =
(
	local res
	if nItem > 0 and nItem <= lv.listItems.count then
	(
		li = lv.listItems[ nItem ]
		res = li.checked
	) 
	else 
		res = false

	return res
) -- end - function GetLvItemCheck 

function SetLvItemCheck lv nItem newState =
(
	if nItem > 0 and nItem <= lv.listItems.count then
	(
		li = lv.listItems[ nItem ]
		li.checked = newState
	) 
) -- end - function SetLvItemCheck 

function SetLvItemRowColor lv nItem newColor =
(
	if nItem > 0 and nItem <= lv.listItems.count then
	(
		li = lv.listItems[ nItem ]
		li.ForeColor = newColor
		local si = li.ListSubItems
		for i in si do
			i.ForeColor = newColor
	) 
) -- end - function SetLvItemRowColor 

-- Added elements are by default at the end.
-- key must be string that is not convertable to a number.
-- return the listItem
function AddLvItem _lv textItems checked:false insertAt: tag: key: tooltips: =
(
	if insertAt == unsupplied do insertAt = _lv.ListItems.count + 1
	li = if key == unsupplied then 
			_lv.ListItems.add insertAt 
		 else 
			_lv.ListItems.add insertAt key
		
	if _debug do format "add list item: %, insert at: %, count: %\n" textItems insertAt _lv.ListItems.count
	
	li.checked = (checked == 1 or checked == true)
	if tag != unsupplied do li.tag = tag
	-- li.ghosted = if _on == 2 then true else false
	
	if textItems.count > 0 do
		li.text = textItems[1]
	if tooltips != unsupplied do
		if tooltips[1] != "" do li.toolTipText = tooltips[1]
	
	-- remaining columns are in a subItem
	for i = 2 to textItems.count do
	(
		local li2 = li.ListSubItems.add()
		li2.text = textItems[i]
		if tooltips != unsupplied do
			if tooltips[i] != "" do li2.toolTipText = tooltips[i]
	)
	return li
) -- end - function AddLvItem 

-- Pretty straightforward...
function DeleteLvItem lv item =
(
	if _debug do format "delete list item: %\n" item
	if( item != undefined ) and (item > 0) and (item <= lv.listItems.count) then
		lv.listItems.remove item
) -- end - function DeleteLvItem

------------------------------------------------------------------
--
--	Main Texture Baking Shell Rollout
--
rollout gTextureBakeDialog "Render To Texture" 
	width:345 height:485
(
	-- local functions
	local OnObjectSelectionChangeEvent, OnObjectSelectionChange, OnReset, OnFileOpen, OnNodeRenamed, ReadConfigData, WriteConfigData 
	
	-- local variables used for data exchange with Missing Map Coords dialog and Missing Map Targets dialog
	local missingDataList = #()
	local cancelRender = false
	
	local nodeSelectionEventRegistered = false 
	
	-- sub rollout for selected object porperties
	SubRollout rollouts "" pos:[1,2] width:342 height:483
	
	-- the "do it" buttons

	button bRender "Render" width:66 height:24 align:#left enabled:true offset:[-6,0]
	button bMapOnly "Unwrap Only" width:70 height:24 align:#left enabled:true offset:[67,-24]
	button bClose "Close" width:50 height:24 align:#left enabled:true offset:[144,-24]
	label l1 "Views  Render" align:#left enabled:true offset:[247,0]
	label l2 "Original:" align:#left enabled:true offset:[205,0]
	label l3 "Baked:" align:#left enabled:true offset:[205,0]
	radiobuttons rOrigOrBaked ""  labels:#("", "") default:2 align:#left columns:1 offset:[256,-24]
	radiobuttons rOrigOrBaked2 "" labels:#("", "") default:1 align:#left columns:1 offset:[291,-24]
			
	-------------------------------------------------------------
	--	
	--	Bake Texture Button Pressed
	--	
	on bRender pressed do if workingObjects.count != 0 do
	(
		selectedObjectProps.CloseWorkingObjects()  -- capture changes
		selectedElementProps.CloseSelectedElement()  -- capture changes
--		selectedElementProps.OnObjectSelectionChange() -- reselect elements

		-- flatten everybody
		ignoreSelectionUpdates = true
		if doAutoUnwrap do 
		(
			-- update bake channel on nodes
			for obj_i in workingObjects do
				obj_i.node.INodeBakeProperties.bakeChannel = autoUnwrapChannel 
			BatchFlatten workingObjects commonBakeProps.sThresholdAngle.value commonBakeProps.sSpacing.value \
						 commonBakeProps.cRotate.checked commonBakeProps.cFillHoles.checked
		)
		ignoreSelectionUpdates = false
		
		if _debug do format "bRender pressed - starting test\n"

		if (MapCoordsOK workingObjects ) and ((bakedMtlProps.cbRenderToFilesOnly.checked) or (MapTargetsOK workingObjects)) do
		(
			if _debug do format "bRender pressed - passed test\n"
	
			-- then bake the textures
			ignoreSelectionUpdates = true
			if _debug do format "bRender pressed - calling batchBake\n"
			if commonBakeProps.cNetworkRender.checked then
				NetBatchBake workingObjects
			else
				BatchBake workingObjects 
			ignoreSelectionUpdates = false
		)
	)
		
	-------------------------------------------------------------
	--	
	--	Just do mapping, no render
	--	
	on bMapOnly pressed do if workingObjects.count != 0 do
	(
		selectedObjectProps.CloseWorkingObjects()  -- capture changes
		selectedElementProps.CloseSelectedElement()  -- capture changes

		-- flatten everybody
		ignoreSelectionUpdates = true
		if allow_manual_unwrap_when_autounwrap_off or doAutoUnwrap do 
		(
			-- update bake channel on nodes
			for obj_i in workingObjects do
				obj_i.node.INodeBakeProperties.bakeChannel = autoUnwrapChannel 
			BatchFlatten workingObjects commonBakeProps.sThresholdAngle.value commonBakeProps.sSpacing.value \
						 commonBakeProps.cRotate.checked commonBakeProps.cFillHoles.checked flattenAll:true
		)
		ignoreSelectionUpdates = false
	)

	-------------------------------------------------------------
	--	
	--	Set which submaterial in shell materials to use in viewport for working objects
	on rOrigOrBaked changed state do
	(	
		state -= 1 -- property is 0-based
		for wo in workingObjects do
		(	
			local mtl = wo.node.material
			if mtl != undefined do 
				SetShellMtlVPMtl mtl state
		) 
	)
	
	-------------------------------------------------------------
	--	
	--	Set which submaterial in shell materials to use in renders for working objects
	on rOrigOrBaked2 changed state do
	(	
		state -= 1 -- property is 0-based
		for wo in workingObjects do
		(	
			local mtl = wo.node.material
			if mtl != undefined do 
				SetShellMtlRenderMtl mtl state
		) 
	)
	
	-------------------------------------------------------------
	--	
	--	Close Button pressed 
	--
	on bClose pressed do
	(
		-- format "close button\n"
		-- & close the dialog, save handled by on ... close event
		destroydialog gTextureBakeDialog
	)
		
	-------------------------------------------------------------
	--	
	--	dialog is opening 
	--
	on gTextureBakeDialog open do
	(
		toolMode.commandMode = #SELECT

		bRender.enabled = renderers.current.supportsTexureBaking
		newNodeMtlInstance = StandardMaterial shaderByName:defaultMtlShader 
		newNodeMtlTargetMapNames = CollectTargetMapNamesForMtl newNodeMtlInstance 
		
		unwrapUVW_instance = Unwrap_UVW() 

		-- add new callbacks
		callbacks.addScript #selectionSetChanged "gTextureBakeDialog.OnObjectSelectionChangeEvent()" id:#bakeSelectionHandler 
		callbacks.addScript #systemPreReset "gTextureBakeDialog.OnReset()" id:#bakeResetHandler 
		callbacks.addScript #systemPreNew "gTextureBakeDialog.OnReset()" id:#bakeNewHandler 
		callbacks.addScript #filePreOpen "gTextureBakeDialog.OnFileOpen()" id:#bakeFileOpenHandler 
		callbacks.addScript #postRendererChange "gTextureBakeDialog.OnRendererChanged()" id:#bakeRendererChangedHandler 
	)

	-------------------------------------------------------------
	--	
	--	dialog is being closed. only hook for X Button pressed 
	--
	on gTextureBakeDialog close do
	(
		if _debug do format "close gTextureBakeDialog - begin\n"
		
		-- remove the various callbacks
		callbacks.removeScripts id:#bakeSelectionHandler 
		callbacks.removeScripts id:#bakeResetHandler 
		callbacks.removeScripts id:#bakeNewHandler 
		callbacks.removeScripts id:#bakeFileOpenHandler  
		deleteAllChangeHandlers id:#bakeNodeRenamedHandler
		callbacks.removeScripts id:#bakeRendererChangedHandler 

		-- format "    save open object \n"
		-- save things to the selected object
		selectedObjectProps.CloseWorkingObjects()
		selectedElementProps.CloseSelectedElement()

		-- close any vfbs
		if curBM != undefined then 
			unDisplay( curBM )
		
		if gTextureBakeDialog.placement != #minimized do
			pDialogPos = GetDialogPos( gTextureBakeDialog )
		WriteDialogConfig()
		
		--format "dialog pos = ( %, %) \n" pDialogPos.x pDialogPos.y
		-- & close the dialog if it's not already
		
		if _debug do format "close gTextureBakeDialog - destroydialog start\n"
		destroydialog gTextureBakeDialog
		if _debug do format "close gTextureBakeDialog - end\n"
	)
	
	-------------------------------------------------------------
	--	
	--	Dialog resized 
	--
	on gTextureBakeDialog resized newSz do
	(
		-- format "resize to %, % \n" newSz.x newSz.y
		if gTextureBakeDialog.placement != #minimized do
		(
			pDialogHeight = newSz.y
	 
			-- adjust the dialog layout
			rollouts.height = pDialogHeight - 43
			buttonY = pDialogHeight - 33
			bRender.pos = [bRender.pos.x, buttonY]
			bMapOnly.pos = [bMapOnly.pos.x, buttonY]
			rOrigOrBaked.pos = [rOrigOrBaked.pos.x, buttonY+4]
			rOrigOrBaked2.pos = [rOrigOrBaked2.pos.x, buttonY+4]
			l1.pos = [l1.pos.x, buttonY-8]
			l2.pos = [l2.pos.x, buttonY+4]
			l3.pos = [l3.pos.x, buttonY+19]
			bClose.pos = [bClose.pos.x, buttonY]
		)
	)


	------------------------------------------------------------------
	-- function called when node selection changes. Just registers a redrawviews callback if not ignoring
	-- selection changes, and callback hasn't already been registered
	function OnObjectSelectionChangeEvent =
	(
		if not ignoreSelectionUpdates and not nodeSelectionEventRegistered do 
		(
			registerRedrawViewsCallback OnObjectSelectionChange
			nodeSelectionEventRegistered = true
		)
	)
	------------------------------------------------------------------
	-- function called at redrawviews after node selection changes. Rebuilds object lists, calls 
	-- function to update Elements rollout if needed, and update Objects listview
	function OnObjectSelectionChange =
	(
		if _debug do format "in gTextureBakeDialog.OnObjectSelectionChange: displayType:%\n" selectedObjectProps.rSceneType.state
		if nodeSelectionEventRegistered do
		(
			unregisterRedrawViewsCallback OnObjectSelectionChange
			nodeSelectionEventRegistered = false
		)
		selectedObjects = selection as array
		local newDisplayedBakableObjects = #()
		local newWorkingObjects = #()
		local objData
		local workingObjectSetUnchanged = true
		local displayedObjectSetUnchanged = true
		local displayType = selectedObjectProps.rSceneType.state
		-- build new object lists
		if (displayType <= 2) then -- Displaying All Selected
		(
			for obj in selectedObjects where (ObjectIsBakable obj) do
			(
				objData = bakableObjStruct obj obj.name (CollectMappedChannels obj) (CollectTargetMapNamesForNode obj)
				append newDisplayedBakableObjects objData
			)
			if displayType == 1 then -- working set is Individual
			(
				-- bring across currently picked objects that are still valid
				for obj in workingObjects where (isvalidNode obj.node and obj.node.isSelected) do
				(
					-- find node in newDisplayedBakableObjects. newWorkingObjects values must be a 
					-- subset of the values in newDisplayedBakableObjects. (the same bakableObjStruct)
					-- instance must be in both
					local notFound = true
					local theNode = obj.node
					for o in newDisplayedBakableObjects while notFound where o.node == theNode do
					(
						append newWorkingObjects o
						notFound = false
					)
				)
				-- if all else fails, make first object the working object
				if newWorkingObjects.count == 0 and newDisplayedBakableObjects.count != 0 do
					append newWorkingObjects newDisplayedBakableObjects[1]
			)
			else -- working set is All Selected
				newWorkingObjects = newDisplayedBakableObjects
		)
		else -- Displaying All Prepared, working set is All Prepared
		(
			for obj in geometry where (ObjectIsBakable obj) do
			(
				local channels = CollectMappedChannels obj
				if channels.count != 0 do
				(
					objData = bakableObjStruct obj obj.name channels (CollectTargetMapNamesForNode obj)
					append newDisplayedBakableObjects objData
				)
			)
			newWorkingObjects = newDisplayedBakableObjects
		)

		-- perform node bake channel fixup
		-- clamp bake channel to range of 1 to 99
		-- if node's bake channel doesn't match uvw map channels, set it to first uvw map channel
		-- if no uvw map channels, leave bake channel alone
		-- turn off undo for this so don't get undo record/dirty scene just by opening RTT
		with undo off 
		(
			for obj in newDisplayedBakableObjects do
			(
				local bakeInterface = obj.node.INodeBakeProperties
				if bakeInterface.bakeChannel < 1 then bakeInterface.bakeChannel = 1
				else if bakeInterface.bakeChannel > 99 then bakeInterface.bakeChannel = 99
				if (not obj.channels[bakeInterface.bakeChannel]) and (not obj.channels.isEmpty) do
				(	local firstChannel
					for i in obj.channels while (firstChannel = i;false) do () -- quick way to get first set 
					bakeInterface.bakeChannel = firstChannel
				)
			)
			if (newWorkingObjects != newDisplayedBakableObjects) do -- if both aren't the same array
			(
				for obj in newWorkingObjects do
				(	local bakeInterface = obj.node.INodeBakeProperties
					if (not obj.channels[bakeInterface.bakeChannel]) and (not obj.channels.isEmpty) do
					(	local firstChannel
						for i in obj.channels while (firstChannel = i;false) do () -- quick way to get first set 
						bakeInterface.bakeChannel = firstChannel
					)
				)
			)
		) -- end undo off 

		if _debug do
		(	
			format "  selectedObjects: %\n" selectedObjects 
			format "  newDisplayedBakableObjects: %\n" newDisplayedBakableObjects 
			format "  newWorkingObjects: %\n" newWorkingObjects
		)
		-- check to see if the new working object list is the same as the old
		-- if so, no need to change the Elements rollout. Otherwise need to 
		-- accept any changes there and redisplay
		if newWorkingObjects.count != workingObjects.count then
			workingObjectSetUnchanged = false
		else
			for i = 1 to newWorkingObjects.count while (workingObjectSetUnchanged) do
				if newWorkingObjects[i].node != workingObjects[i].node do
					workingObjectSetUnchanged = false
		
		-- update the nodes' and elements' data if needed
		if workingObjects.count != 0 and not workingObjectSetUnchanged do
		(
			selectedObjectProps.CloseWorkingObjects()
			selectedElementProps.CloseSelectedElement()
		)
			
		-- decide whether we need to update the node listview.
		if newDisplayedBakableObjects.count != displayedBakableObjects.count then
			displayedObjectSetUnchanged = false
		else
			for i = 1 to newDisplayedBakableObjects.count while (displayedObjectSetUnchanged) do
				if newDisplayedBakableObjects[i].node != displayedBakableObjects[i].node do
					displayedObjectSetUnchanged = false
		
		displayedBakableObjects = newDisplayedBakableObjects
		workingObjects = newWorkingObjects
		for wo in workingObjects do wo.isWorkingObject = true
		
		-- update the Objects listview if needed
		if (not displayedObjectSetUnchanged) then
			selectedObjectProps.RebuildObjectsLV()
	
		-- update the common Object settings if needed and refresh node listview
		else if (not workingObjectSetUnchanged) do
		(
			selectedObjectProps.UpdateObjectSettings()
			selectedObjectProps.RefreshObjectsLV() -- update listview
		)
	
		-- update the Elements listview if needed
		if (not workingObjectSetUnchanged) do
			selectedElementProps.OnObjectSelectionChange() -- display elements for working object

		-- update the Views radio button if needed
		if (not workingObjectSetUnchanged) do
		(
			local res = triStateValue()
			for wo in workingObjects do
			(	
				local mtl = wo.node.material
				if mtl != undefined do 
					GetShellMtlVPMtl mtl res
			)
			if res.defined == false then
				rOrigOrBaked.state = 2
			else if res.indeterminate then 
				rOrigOrBaked.state = 0
			else
				rOrigOrBaked.state = res.value + 1 -- prop is 0-based
			
		)

		-- update the Render radio button if needed
		if (not workingObjectSetUnchanged) do
		(
			local res = triStateValue()
			for wo in workingObjects do
			(	
				local mtl = wo.node.material
				if mtl != undefined do 
					GetShellMtlRenderMtl mtl res
			)
			if res.defined == false then
				rOrigOrBaked2.state = 1
			else if res.indeterminate then 
				rOrigOrBaked2.state = 0
			else
				rOrigOrBaked2.state = res.value + 1 -- prop is 0-based
			
		)

		if (not displayedObjectSetUnchanged) then
		(
			if _debug do format "registering node rename callback\n"
			deleteAllChangeHandlers id:#bakeNodeRenamedHandler
			local nodelist = for obj in displayedBakableObjects collect obj.node
			when names nodelist change id:#bakeNodeRenamedHandler theNode do OnNodeRenamed theNode
		)
	) -- end - function OnObjectSelectionChange 
			
	-----------------------------------------------------------------------------
	--
	-- this function handles reset & new event callbacks
	--
	function OnReset =
	(
		if curBM != undefined then
		(	close curBM
			curBM = undefined
		)

		-- & close the dialog if it's not already
		destroydialog gTextureBakeDialog
	) -- end - function OnReset 

	function OnFileOpen =
	(
	) -- end - function OnFileOpen 
	
	function OnNodeRenamed theNode =
	(	
		-- check to make sure that an actual node name change occurred. The 'when name changed' gets
		-- triggered when the node, node modifiers', or node material's name changes.
		local wo_index
		local notFound = true
		for i = 1 to workingObjects.count while notFound where workingObjects[i].node == theNode do
		(	notFound = false
			wo_index = i
		)
		if (not notFound) and workingObjects[wo_index].nodeName != theNode.name do
		(
			if _debug do format "in OnNodeRenamed: %\n" theNode.name
			selectedObjectProps.RefreshObjectsLV updateNodeNames:true -- update listview
			if workingObjects.count == 1 and workingObjects[1].node == theNode do
			(	
				selectedElementProps.CloseSelectedElement()
				selectedElementProps.OnObjectSelectionChange()
			)
		)
	) -- end - function OnNodeRenamed 
	
	function OnRendererChanged =
	(
		bRender.enabled = renderers.current.supportsTexureBaking
		if (not renderers.current.supportsTexureBaking and not RTT_Data.rendererErrorDisplayed ) do 
		(
			messagebox "Renderer doesn't support Texture Baking, Rendering disabled\n"
			RTT_Data.rendererErrorDisplayed = true
		)

	)
	
	function ReadConfigData =
	(
		defaultFileType = RTT_data.FileOutput_FileType
	) -- end - function ReadConfigData 
	
	function WriteConfigData =
	(
		RTT_data.FileOutput_FileType = defaultFileType
	) -- end - function WriteConfigData 

) -- end - rollout gTextureBakeDialog

------------------------------------------------------------------
--
--	Common Settings Rollout - these apply to the whole scene
--
rollout commonBakeProps "General Settings"
(
	-- local functions
	local GetFilePath, UpdateFlattenEnables, ReadConfigData, WriteConfigData, RebuildRenderPresets
	
	-- the auto flatten group
	group "Automatic Unwrap Mapping"
	(
		checkbox cAutoFlattenOn "On" checked:false align:#left across:3
		spinner sMapChannel "Map Channel: " range:[1,99,3] type:#integer fieldwidth:40 align:#right offset:[-30,0]
		checkbox cRotate "Rotate Clusters" checked:true align:#left offset:[-15,0]
		label l_dummy1 "" across:3
		spinner sThresholdAngle "Threshold Angle: " range:[1,100,45] type:#float fieldwidth:40 align:#right offset:[-30,0]
		checkbox cFillHoles "Fill Holes" checked:true align:#left offset:[-15,0]
		label l_dummy2 "" across:3
		spinner sSpacing "Spacing: " range:[0,1,0.02] type:#float scale:0.001 fieldwidth:40 align:#right offset:[-30,0]
		button bClearUnwrap "Clear Unwrappers" width:110 height:16 align:#left offset:[-15,0]
	)
	
-- autosize group
	group "Automatic Map Size"
	(
		spinner sSizeScale "Scale: " range:[0,1,0.01] type:#float scale:0.001 across:2 align:#left
		spinner sSizeMin "Min: " range:[1,2048,32] type:#integer align:#right
		checkbox cSizePowersOf2 "Nearest power of 2" across:2 align:#left
		spinner sSizeMax "Max:" range:[1,2048,1024] type:#integer align:#right
	)
	
-- path group
	group "Output" 
	(
		edittext eFilePath "Path: " width:270 across:2 align:#left
		button bPathSelect "..." width:20 height:17 align:#right
		checkbox cSkipExistingFiles "Skip Existing Files" across:2 align:#left
		checkbox cDisplayFB "Rendered Frame Window" align:#left checked:true 
	)
	
-- Render Setting group
	group "Render Settings"
	(
--		radiobuttons rDraftOrProduction "" width:146 labels:#("Production", "Draft") columns:2 across:2
		dropdownlist dRenderPresets across:2
		button setupRenderSettingsButton "Setup..." width:60 height:16 
		checkbox cNetworkRender "Network Render" align:#left offset:[0,-3]
	)

	on commonBakeProps open do
	(
		ReadConfigData()
		RebuildRenderPresets()
		dRenderPresets.selection = renderPresetFiles.count+1
				
		autoUnwrapChannel = sMapChannel.value
		doAutoUnwrap = cAutoFlattenOn.state
		
		cNetworkRender.enabled = classof netrender == Interface
		if not cNetworkRender.enabled do cNetworkRender.checked = false

		UpdateFlattenEnables cAutoFlattenOn.checked
	)
	on commonBakeProps close do
	(
		if _debug do format "close commonBakeProps\n"
		WriteConfigData()
	)
	on cAutoFlattenOn changed _newState do
	(
		-- enable auto flatten controls
		doAutoUnwrap = _newState
		UpdateFlattenEnables _newState 
		selectedObjectProps.AutoMapChannelStateChanged()
	)
	on sMapChannel changed val do
	(
		autoUnwrapChannel = val 
		selectedObjectProps.AutoMapChannelValChanged()
	)
	on bClearUnwrap pressed do
	(
		RemoveFlatteners ()
	)
--	on rDraftOrProduction changed _newState do
--	(
--		renderer = if (_newState == 1) then #production else #draft
--	)
	on dRenderPresets selected val do
	(
		if val <= renderPresetFiles.count then
		(
			res = renderPresets.load 0 renderPresetFiles[val] #{}
		)
		else if val == (renderPresetFiles.count+2) do
		(
			renderPresets.load 0 "" #{}
			RebuildRenderPresets()
			dRenderPresets.selection = 1
		)
	)
	on setupRenderSettingsButton pressed do
	(
		-- select the settings to use
--		renderer = if (commonBakeProps.rDraftOrProduction.state == 1) then #production else #draft
		max render scene
	)
	on cNetworkRender changed state do
	(
		bakedMtlProps.cbRenderToFilesOnly.enabled = not state
	)
	on cSizePowersOf2 changed _newVal do
	(
		selectedElementProps.UpdateAutoSize()
	)
	on sSizeScale changed _newVal do
	(
		selectedElementProps.UpdateAutoSize()
	)
	on sSizeMin changed _newVal do
	(
		selectedElementProps.UpdateAutoSize()
	)
	on sSizeMax changed _newVal do
	(
		selectedElementProps.UpdateAutoSize()
	)
	on eFilePath changed _newPath do
	(
		if _newPath == "" then
			eFilePath.text = getdir #image
	)
	on bPathSelect pressed do
	(
		path = GetSavePath caption:"Select Output Path" 
		if path != undefined then
			eFilePath.text = path
	)

	-- return the effective file path
	function GetFilePath = 
	(
		path = eFilePath.text
		if path == "" then
		(
			path = getdir #image		-- image directory is the default
		)
		if path[ path.count ] != "\\" then
			path += "\\"

		-- format "        file path: % \n" path
		return path
	)

	-- enable/disable auto-flatten controls  
	function UpdateFlattenEnables _enable =
	(
		sMapChannel.enabled = _enable
		sThresholdAngle.enabled = _enable				
		sSpacing.enabled = _enable				
		cRotate.enabled = _enable			
		cFillHoles.enabled = _enable
	)			

	function ReadConfigData =
	(
		-- format "load state\n"
	
		cAutoFlattenOn.checked =	RTT_data.AutoFlatten_On
		sSpacing.value = 			RTT_data.AutoFlatten_Spacing
		sThresholdAngle.value = 	RTT_data.AutoFlatten_ThresholdAngle
		cRotate.checked = 			RTT_data.AutoFlatten_Rotate
		cFillHoles.checked =		RTT_data.AutoFlatten_FillHoles
		sMapChannel.value = 		RTT_data.AutoFlatten_MapChannel
		
		sSizeMin.value = 			RTT_data.AutoSize_SizeMin
		sSizeMax.value = 			RTT_data.AutoSize_SizeMax
		sSizeScale.value = 			RTT_data.AutoSize_SizeScale
		cSizePowersOf2.checked = 	RTT_data.AutoSize_SizePowersOf2
		
		cDisplayFB.checked = 		RTT_data.Renderer_DisplayFB
		cNetworkRender.checked = 	RTT_data.Renderer_NetworkRender
		cSkipExistingFiles.checked = RTT_data.Renderer_SkipExistingFiles
		
		eFilePath.text = 			RTT_data.FileOutput_FilePath
	) -- end fn ReadConfigData 
	
	function WriteConfigData =
	(
		-- format "save state\n"
	 
		RTT_data.AutoFlatten_On = cAutoFlattenOn.checked 
		RTT_data.AutoFlatten_Spacing = sSpacing.value
		RTT_data.AutoFlatten_ThresholdAngle = sThresholdAngle.value
		RTT_data.AutoFlatten_Rotate = cRotate.checked
		RTT_data.AutoFlatten_FillHoles = cFillHoles.checked
		RTT_data.AutoFlatten_MapChannel = sMapChannel.value
		
		RTT_data.AutoSize_SizeMin = sSizeMin.value
		RTT_data.AutoSize_SizeMax = sSizeMax.value
		RTT_data.AutoSize_SizeScale = sSizeScale.value
		RTT_data.AutoSize_SizePowersOf2 = cSizePowersOf2.checked 
		
		RTT_data.Renderer_DisplayFB = cDisplayFB.checked
		RTT_data.Renderer_NetworkRender = cNetworkRender.checked
		RTT_data.Renderer_SkipExistingFiles = cSkipExistingFiles.checked
		
		RTT_data.FileOutput_FilePath = eFilePath.text
		
	) -- end fn WriteConfigData 
	
	function RebuildRenderPresets = 
	(
		LoadRenderPresetList()
		local renderPresetNames = #()
		local count = renderPresetFiles.count
		renderPresetNames.count = count+2
		if _debug do print renderPresetFiles #nomap
		for i = 1 to count do renderPresetNames[i] = getFilenameFile (renderPresetFiles[i])
		renderPresetNames[count+1]="-------------------------------------------------"
		renderPresetNames[count+2]="Load Preset..."
		if _debug do print renderPresetNames #nomap
		dRenderPresets.items = renderPresetNames
	) -- end fn RebuildRenderPresets 
) -- end - rollout commonBakeProps 

------------------------------------------------------------------
rollout selectedObjectProps "Objects to Bake"
(
	-- rollout local functions
	local 	RebuildObjectsLV, RefreshObjectsLV, UpdateObjectSettings, CloseWorkingObjects, AutoMapChannelValChanged, 
			AutoMapChannelStateChanged
			
	local lastSceneType -- holds last display type (individual, all selected, all prepared)
	local settingsDirty -- if true, a parameter of the working object(s) was changed. 
	
	local numVisibleItems = 8 -- number of ListItems visible in lvObjects (constant)

	label l_name1 "" across:3 align:#left offset:[20,-5]
	label l_mapchan1 "Map" align:#right offset:[40,-5]
	label l_edge1 "Edge" align:#right offset:[-10,-5]
	label l_name2 "Name" across:3 align:#left offset:[20,-5]
	label l_mapchan2 "Channel" align:#right offset:[45,-5]
	label l_edge2 "Padding" align:#right offset:[-5,-5]

	activeXControl lvObjects "MSComctlLib.ListViewCtrl" height:118 width:330 align:#left offset:[-14,-5]

	group "Selected Object Settings"
	(
		checkbox cBakeEnable "Enabled" enabled:false checked:false align:#left offset:[0,-1] across:4
		label l_mapChannel "Channel:" align:#left offset:[20,0] 
		dropdownlist dUseMapChannel "" enabled:false width:50 align:#left offset:[0,-3]
		spinner sDilations "Padding: " enabled:false range:[0,16,2] type:#integer fieldwidth:40 align:#right
	)

	radiobuttons rSceneType "" labels:#("Individual", "All Selected    ", "All Prepared") default:2 columns:3

	------------------------------------------------------------------
	-- on open we need to initialize the list view & set things appropriately
	--
	on selectedObjectProps open do
	(
		InitListView lvObjects 4 #("","Name","Map Channel","Edge Padding") #(0,211,56,44) checkBoxes:false -- init the active x list view
--		InitListView lvObjects 4 #("","Name","Map Channel","Edge Padding") #(15,218-15,51,44) checkBoxes:true -- init the active x list view
--		lvObjects.columnheaders[1].width=450
		lvObjects.sortKey = 1
		lvObjects.sorted = true
		lvObjects.hideSelection = true
		lvObjects.fullRowSelect = false
		lastSceneType = undefined
		settingsDirty = false
	)  --end, on open

	-- This event is called once an item is clicked
	on lvObjects click do
	(
		local sel = GetLvSelection lvObjects 
		-- if _debug do format "click select: % \n" sel
		if sel != 0 and (not displayedBakableObjects[lvObjects.listItems[sel].tag].isWorkingObject) do
		(
			CloseWorkingObjects() -- accept changes on working objects
			selectedElementProps.CloseSelectedElement() -- accept changes on working elements
			for wo in workingObjects do wo.isWorkingObject = false 
			workingObjects = #(displayedBakableObjects[lvObjects.listItems[sel].tag])
			for wo in workingObjects do wo.isWorkingObject = true
			UpdateObjectSettings() -- update working object settings
			RefreshObjectsLV() -- update listview
			selectedElementProps.OnObjectSelectionChange() -- display elements for working object
		)
	)

	on lvObjects keyup key shift do 
		if key == 38 or key == 40 do lvObjects.click() -- 38 - up ; 40 down
	
	on cBakeEnable changed state do
	(
		settingsDirty = true
	)
	
	on dUseMapChannel selected val do 
	(	
		settingsDirty = true
		RefreshObjectsLV workingObjectsOnly:true
	)
	
	on sDilations changed val do 
	(	
		settingsDirty = true
		RefreshObjectsLV workingObjectsOnly:true
	)

	-- handler called when changing between Individual/All Selected/All Prepared
	on rSceneType changed newState do
	(
		-- update the nodes' and elements' data if needed
		if workingObjects.count != 0 do
		(
			CloseWorkingObjects() -- accept changes on working objects
			selectedElementProps.CloseSelectedElement() -- accept changes on working elements
		)
		
		if newState == 1 then -- Individual
		(	lvObjects.hideSelection = false
			lvObjects.fullRowSelect = true
			if lastSceneType == 2 then -- was All Selected. 
			(
				if displayedBakableObjects.count != 0 do
				(	-- See if last picked node is still visible. If so, leave it as picked node. If not, find 
					-- first visible node in list and pick it
					local pickedNode = GetLvSelection lvObjects 
					local firstVisible = (lvObjects.GetFirstVisible()).index
					-- if _debug do format "picked item test: % : % : %\n" pickedNode firstVisible (if pickedNode != 0 then lvObjects.listItems[pickedNode].tag else "X")
					if pickedNode >= firstVisible and pickedNode < (firstVisible + numVisibleItems) then
						workingObjects = #(displayedBakableObjects[lvObjects.listItems[pickedNode].tag])
					else
					(
						workingObjects = #(displayedBakableObjects[lvObjects.listItems[firstVisible].tag])
						SelectLvItem lvObjects 0 -- clear current selection
						SelectLvItem lvObjects firstVisible
					)
				)
			)
			else -- was All Prepared
			(
				workingObjects = #()
				gTextureBakeDialog.OnObjectSelectionChange()
				if (displayedBakableObjects.count != 0) do
				(
					workingObjects = #(displayedBakableObjects[lvObjects.listItems[1].tag])
					SelectLvItem lvObjects 0 -- clear current selection
					SelectLvItem lvObjects 1
				)
			)
			
			for dbo in displayedBakableObjects do dbo.isWorkingObject = false
			for wo in workingObjects do wo.isWorkingObject = true
			
			UpdateObjectSettings()
			RefreshObjectsLV()
			selectedElementProps.OnObjectSelectionChange() -- display elements for working object
		)
		else 
		(
			lvObjects.hideSelection = true
			lvObjects.fullRowSelect = false
			gTextureBakeDialog.OnObjectSelectionChange()
		)
		
		lastSceneType = newState
		setFocus lvObjects
	)
	 
	-- Function to fill in LvObjects
	function RebuildObjectsLV =
	(	
		if _debug do format "in selectedObjectProps.RebuildObjectsLV \n"
		-- remove all items from the listview
		lvObjects.listItems.clear()

		-- add the list items and sublist items
		local index = 0
		for obj in displayedBakableObjects do
		(
			local args = #("",obj.node.name,"","")
			AddLvItem lvObjects args tag:(index += 1) tooltips:args
		)
		
		UpdateObjectSettings() -- update Selected Object Settings 
		
		RefreshObjectsLV() -- fill in sublist item text
		
		SelectLvItem lvObjects 0 -- clear current selection
		
		if _debug do format "\trebuild wo update: % : %\n" workingObjects.count rSceneType.state 
		if workingObjects.count == 1 and rSceneType.state == 1 then
		(	
			local notFound = true
			if _debug do 
				for li in lvObjects.listItems do format "\t% : %\n" li.tag displayedBakableObjects[li.tag]
			for li in lvObjects.listItems while notFound where displayedBakableObjects[li.tag].isWorkingObject do
			(	lvObjects.Refresh() -- needed to make li.EnsureVisible() work, otherwise li.index is wrong (sort doesn't occur until refresh?)
				li.selected = true
				li.EnsureVisible()
				notFound = false
				if _debug do format "\tset: % : %\n" li.tag li.index
			)
		)
				
	) -- end function RebuildObjectsLV  
	
	-- Function to refresh LvObjects
	-- Selected Object Settings UI items must have be updated before calling this method.
	function RefreshObjectsLV workingObjectsOnly:false updateNodeNames:false =
	(	
		if _debug do format "in selectedObjectProps.RefreshObjectsLV - workingObjectsOnly:%\n" workingObjectsOnly
		-- For working objects: 
		-- if Automatic Unwrap Mapping is on, use the Map Channel specified there as map channel on all objects
		-- otherwise, use channel from the Channel dropdown if a channel is specified there, 
		-- otherwise, will use channel from the node if valid, blank if not
		-- For non-working objects, use channel from the node if valid, blank if not
		local s_autoUnwrapChannel, newChannel_string
		local useNewChannel_string = false
		if doAutoUnwrap then
			s_autoUnwrapChannel = autoUnwrapChannel as string
		else
		(
			newChannel_string = dUseMapChannel.selected 
			useNewChannel_string = (newChannel_string != "" and newChannel_string != undefined)
		)
		
		-- For working objects: 
		-- use padding value from the padding spinner if a value is specified there, 
		-- otherwise, will use nDilations value from the node
		-- For non-working objects, use nDilations value from the node
		local newPadding_string
		local useNewPadding_string = not sDilations.indeterminate
		if useNewPadding_string do
			newPadding_string = sDilations.value as string
		
		for li in lvObjects.listItems do
		(	
			obj = displayedBakableObjects[li.tag]
			if (not workingObjectsOnly) or obj.isWorkingObject do -- don't update unless we are supposed to
			(
				local channel
				if doAutoUnwrap and obj.isWorkingObject then
					channel = s_autoUnwrapChannel
				else if (not doAutoUnwrap) and obj.isWorkingObject and useNewChannel_string then
					channel = newChannel_string
				else
				(	-- if no uvw map channels, just display a blank
					if (obj.channels.isEmpty) then
						channel = ""
					else
						channel = obj.node.INodeBakeProperties.bakeChannel as string
				)
				
				local padding
				if obj.isWorkingObject and useNewPadding_string then
					padding = newPadding_string
				else
					padding = obj.node.INodeBakeProperties.nDilations as string
				
				if updateNodeNames do
					li.listSubItems[1].text = obj.node.name
				li.listSubItems[2].text = channel
				li.listSubItems[3].text = padding
			)
		)
	) -- end function RefreshObjectsLV
	
	-- function to update the Selected Object Settings UI items
	function UpdateObjectSettings =
	(
		if _debug do format "in selectedObjectProps.UpdateObjectSettings - workingObjects: %\n" workingObjects
		if workingObjects.count == 0 then
		(
			dUseMapChannel.items=#()
			dUseMapChannel.enabled = false
			cBakeEnable.state = false
			cBakeEnable.enabled = false
			sDilations.indeterminate = true
			sDilations.enabled = false
		)
		else
		(
			cBakeEnable.enabled = sDilations.enabled = true
			
			local isEnabled = triStateValue()
			local mapChannel = triStateValue()
			local dilations = triStateValue()
				
			for obj in workingObjects do
			(
				local bakeInterface = obj.node.INodeBakeProperties
				isEnabled.setVal bakeInterface.bakeEnabled
				mapChannel.setVal bakeInterface.bakeChannel
				dilations.setVal bakeInterface.nDilations
				-- if _debug do format "node props: % % % : % % %\n" isEnabled mapChannel dilations bakeInterface.bakeEnabled bakeInterface.bakeChannel bakeInterface.nDilations
			)
			
			cBakeEnable.triState = isEnabled.asTriState()
			
			if dilations.indeterminate then
				sDilations.indeterminate = true
			else
			(
				sDilations.indeterminate = false
				sDilations.value = dilations.value
			)
			
			-- if Automatic Unwrap Mapping is on, use the Map Channel specified there
			-- if off, find common map channels 
			if doAutoUnwrap then
			(
				dUseMapChannel.enabled = false
				dUseMapChannel.items=#()
			)
			else
			(
				dUseMapChannel.enabled = true
				local uvw_mapChannels = #{1..99}
				for obj in workingObjects do
					uvw_mapChannels *= obj.channels
				-- uvw_mapChannels contains common map channels. If we have a value for mapChannel (i.e., a single common 
				-- bake channel), see if that channel is in the common map channels. If so, make sure it is displayed,
				-- otherwise use first item.
				local selectedItem = undefined
				if (not mapChannel.indeterminate) and uvw_mapChannels[mapChannel.value] do
					selectedItem = mapChannel.value
				local uvw_mapChannels = uvw_mapChannels as array -- convert to integer array
				if selectedItem != undefined do -- have value, need index
					selectedItem = findItem uvw_mapChannels selectedItem
				for i = 1 to uvw_mapChannels.count do -- convert to text array
					uvw_mapChannels[i] = uvw_mapChannels[i] as string
				dUseMapChannel.items=uvw_mapChannels -- set the dropdown list
				if selectedItem != undefined do
					dUseMapChannel.selection = selectedItem 
			) 
		) -- workingObjects.count != 0
	) -- end fn UpdateObjectSettings 

	-------------------------------------------------------
	-- function to close the working object & update properties for the
	-- objects. Not done on cancel
	-- called when switching objects in the UI or in listview, on Close, and when changing display types
	-- NB: switching objects writes the changes with no cancel & no undo ...
	function CloseWorkingObjects =
	(
		if settingsDirty do
		(
			if _debug do format "in selectedObjectProps.CloseWorkingObjects: \n" 
	
			-- for each object in the selection
			for obj in workingObjects where isValidNode obj.node do
			(
				local bakeInterface = obj.node.INodeBakeProperties
				if _debug do format "\tclose object: % \n" obj.node.name
				
				-- check for confused, only set un-confused elements!
				if selectedObjectProps.cBakeEnable.triState != 2 then
					bakeInterface.bakeEnabled = selectedObjectProps.cBakeEnable.checked
					
				if dUseMapChannel.selected != undefined and dUseMapChannel.selected != "" then
					bakeInterface.bakeChannel = dUseMapChannel.selected as integer
					
				if sDilations.indeterminate == false then
					bakeInterface.nDilations = sDilations.value
			) 
			RefreshObjectsLV workingObjectsOnly:true
			settingsDirty = false
		)
	) -- end function CloseWorkingObjects

	function AutoMapChannelValChanged =
	(
		if doAutoUnwrap do 
			RefreshObjectsLV workingObjectsOnly:true
	) -- end function AutoMapChannelValChanged

	function AutoMapChannelStateChanged =
	(
		UpdateObjectSettings()
		RefreshObjectsLV workingObjectsOnly:true
	) -- end function AutoMapChannelStateChanged 
	
) -- end - rollout selectedObjectProps 

------------------------------------------------------------------
--
--	add bake elements popup dialog
--
rollout addElementsDialog "Add Texture Elements" 
	width:177 height:239
(
	local elementClasses -- List of all available bake element plug-ins
	local creatableElementClasses -- List of all available bake element plug-ins
	
	multiListBox mlAvailableElements "Available Elements"
		pos:[9,8] width:154 height:10 -- height is measured in Lines, not pixels
	button bCancel "Cancel" 
		pos:[102,201] width:52 height:24
	button bAddSelectedElements "Add Elements" 
		pos:[14,201] width:79 height:24
		
	on mlAvailableElements doubleClicked nClicked do
	(
		bAddSelectedElements.pressed()
	)
		
	-- prepare the class list
	on addElementsDialog open do
	(
		elementsName = #()
		creatableElementClasses = #()
	
		elementClasses = BakeElement.classes
		
		-- collect element classes being used by working objects
		local eleClassesPerNode = #()
		for obj in workingObjects do
		(
			local bakeInterface = obj.node.INodeBakeProperties
			local nBakeElements = bakeInterface.NumBakeElements()
			local eleClasses = for nEle = 1 to nBakeElements collect (classof (bakeInterface.GetBakeElement nEle))
			append eleClassesPerNode eleClasses
		)
		local commonEleClasses = CollectCommonElements eleClassesPerNode 
		
		-- strip ele classes used by all working objects from elementClasses 
		for eleClass in commonEleClasses do 
		(
			local i = findItem elementClasses eleClass 
			if i != 0 do deleteItem elementClasses i
		)
		
		for i in elementClasses do
		(
			-- eliminate the standin
			if i.creatable then
			(
				tmpEle = i()
				append elementsName tmpEle.elementName
				append creatableElementClasses i
			)
		)
		mlAvailableElements.items = elementsName
		
		-- no selection to begin
		mlAvailableElements.selection = #{}
	)
	
	on addElementsDialog close do
	(
		pAddElementsPos = GetDialogPos addElementsDialog 
	)

	-- Cancel handler
	on bCancel pressed do
	(
		-- just destroy the dialog
		destroydialog addElementsDialog 
	)
	
	-- Add the elements to the bake properties
	on bAddSelectedElements pressed do
	(
		--format "add selected: % \n" mlAvailableElements.selection
		
		-- save current edited params
		selectedElementProps.CloseSelectedElement()	
		
		local selectObjSettingNeedsUpdate = false
		-- add the selected elements
		for i in mlAvailableElements.selection do
		(
			local elementClass = creatableElementClasses [i]
			-- create an instance of the elementClass and add it to the 
			-- node's bake properties for each object in the working objects
			--format "bake element: %\n" (creatableElementClasses [ i ]) 
			for obj in workingObjects do
			(
				local bakeInterface = obj.node.INodeBakeProperties
				-- check to see if we already have an instance of the bake element class. Can have only
				-- one per node.
				local found = false
				local nBakeElements = bakeInterface.NumBakeElements()
				for nEle = 1 to nBakeElements while not found do
					if classof (bakeInterface.GetBakeElement nEle) == elementClass do found = true
				
				if not found do
				(
					tmpEle = elementClass() -- new instance for every object
					tmpEle.filename = RTT_methods.MakeBakeElementFileName obj.node tmpEle "" "" defaultFileType 
					-- set the elements targetMapSlotName with the default if that slot isn't already a target
					local targetMapSlotName = GetDefaultMtlMapSlotMapping (bakeElementStruct tmpEle obj.node)
					if (findItem obj.mapSlotNames targetMapSlotName) == 0 do targetMapSlotName = ""
					if targetMapSlotName != "" do
					(
						found = false
						for nEle = 1 to nBakeElements while not found do
						(
							local ele = bakeInterface.GetBakeElement nEle
							if (stricmp ele.targetMapSlotName targetMapSlotName) == 0 do 
							(	
								targetMapSlotName = ""
								found = true
							)
						)
					)
					tmpEle.targetMapSlotName = targetMapSlotName
					bakeInterface.addBakeElement tmpEle
					if not bakeInterface.bakeEnabled do
					(
						selectObjSettingNeedsUpdate = true
						bakeInterface.bakeEnabled = true
					)
				) -- end, not found
			)-- end, for each selected object
		) -- end, item /i in selection
	
		-- destroy the dialog
		destroydialog addElementsDialog 
		
		if selectObjSettingNeedsUpdate do
			selectedObjectProps.UpdateObjectSettings()
		
	)-- end, addSelectedElements
) -- end - rollout addElementsDialog

------------------------------------------------------------------
--
--	Output (Element) Properties Rollout
--
rollout selectedElementProps "Output" width:328 height:381
(
	-- local functions
	local	EnableElementListGroup, EnableSelectedElementGroup, AddElementToList, UpdateElementSz, 
			UpdateElementName, UpdateElementTargetMapName, UpdateElementFileName, UpdateElementCheck, 
			UpdateElementList, CloseSelectedElement, UpdateAutoSize, UpdateSelectedElement, 
			OnObjectSelectionChange, CheckElementFileNames, CheckElementTargetMapNames,
			MakeElementParams, SaveElementParams, EnableElementParams, ReadConfigData, WriteConfigData
			
			
	local	elementPropControls -- will contain array of the cParamX checkboxes
	local	maxNumElementParams = 9 -- max number of allowed Element parameters (constant). 
	local	commonTargetMapSlots = #() -- will contain an array of the target map slots common to the working nodes
	
		-- bake elements list 
	activeXControl lvElements "MSComctlLib.ListViewCtrl" height:118 width:330 align:#left offset:[-14,-5]
	button bAddElement "Add..." width:54 height:20 enabled:false across:2
	button bDeleteElement "Delete" width:54 height:20 enabled:false

		-- selected bake element's settings
	group "Selected Element Common Settings"
	(
	--	GroupBox gElementSettings "Selected Element Common Settings" width:318 height:131 enabled:false
		checkbox cElementEnable "Enable" enabled:false checked:true align:#left
		edittext eName "Name:" fieldwidth:180 enabled:false align:#right offset:[-17,-19]
		edittext eFilename "File Name and Type:" fieldwidth:180 enabled:false align:#right offset:[-17,0]
		button bFindFile "..." enabled:false align:#right width:20 height:17 offset:[6,-22]
		label l_targMapSlot "Target Map Slot: " enabled:false across:2 align:#left offset:[23,2] 
		dropdownlist dTargMapSlot "" width:183 align:#right offset:[-13,0]
		
			-- the size stuff
		checkbox cAutoSz "Use Automatic Map Size" enabled:false align:#left across:3
		label lbl1 "Element Type: " enabled:false align:#right offset:[20,1]
		label lbl_ElementType "" align:#left offset:[20,1]
		spinner sWidth "Width: " width:86 height:16 enabled:false range:[0,8192,256] type:#integer fieldwidth:40 align:#right across:4 offset:[10,0]
		button bxsmall  "" width:60 height:15 enabled:false align:#right offset:[15,0]
		button bmedium  "" width:60 height:15 enabled:false align:#right offset:[10,0]
		button bxlarge  "" width:60 height:15 enabled:false align:#right offset:[5,0]
		spinner sHeight "Height: " width:89 height:16 enabled:false range:[0,8192,256] type:#integer fieldwidth:40 align:#right across:4 offset:[10,0]
		button bsmall   "" width:60 height:15 enabled:false align:#right offset:[15,0]
		button blarge   "" width:60 height:15 enabled:false align:#right offset:[10,0]
		button bxxlarge "" width:60 height:15 enabled:false align:#right offset:[5,0] 
	)
	
	group "Selected Element Unique Settings"
	(
		checkbox cParam1 "" enabled:false visible:false align:#left offset:[0,-4] across:3
		checkbox cParam2 "" enabled:false visible:false align:#left offset:[0,-4]
		checkbox cParam3 "" enabled:false visible:false align:#left offset:[0,-4]
		checkbox cParam4 "" enabled:false visible:false align:#left offset:[0,-4] across:3
		checkbox cParam5 "" enabled:false visible:false align:#left offset:[0,-4]
		checkbox cParam6 "" enabled:false visible:false align:#left offset:[0,-4]
		checkbox cParam7 "" enabled:false visible:false align:#left offset:[0,-4] across:3
		checkbox cParam8 "" enabled:false visible:false align:#left offset:[0,-4]
		checkbox cParam9 "" enabled:false visible:false align:#left offset:[0,-4]
	)
		
	------------------------------------------------------------------
	-- on open we need to initialize the listview & set things appropriately
	--
	on selectedElementProps open do
	(
		ReadConfigData()
		InitListView lvElements 4 #("File Name","Element Name","Size", "Target Map Slot") #(100,100,100,100) hideHeaders:false checkBoxes:false -- init the active x list view
		elementPropControls = #(cParam1,cParam2,cParam3,cParam4,cParam5,cParam6,cParam7,cParam8,cParam9)
		local sizeButtons = #(bxsmall,bsmall,bmedium,blarge,bxlarge,bxxlarge)
		for i = 1 to sizeButtons.count do
		(	local s = mapPresets[i] as string
			sizeButtons[i].caption = s + "x" + s
		)
	)  --end, on open
	
	on selectedElementProps close do
	(
		writeConfigData()
	)  --end, on close
	
	-------------------------------------------------
	-- Add Element Button
	--
	on bAddElement pressed do
	(
		-- format "add elements\n"
		if workingObjects.count > 0 then
		(
			-- bring up dialog w/ class list of available elements
			-- which may add to the selected nodes elements
			local startCount = lvElements.listItems.count
			createDialog addElementsDialog modal:true pos:pAddElementsPos 
			
			-- add new elements to listbox
			-- format "update element list ...\n"
			UpdateElementList()
			
			-- select first of the new elements, if any
			if lvElements.listItems.count > startCount do
				UpdateSelectedElement (startCount+1)
					
			enableAccelerators = false
		) -- end, object selected
	)
	
	
	-------------------------------------------------
	-- Delete Element Button
	--
	on bDeleteElement pressed do
	(
		-- selection 0 is no selection
		if selectedElementIndex  > 0 then
		(
			-- for the selected element list...
			local eleList = commonElements[ selectedElementIndex ]
				
			-- format "remove elements: %\n" (eleList as string)
			-- for each element....
			for ele in eleList do
				ele.node.RemoveBakeElement ele.element
	
			-- update the list 
			UpdateElementList ()
			
			-- update new selected element
			selectedElement = undefined 	-- we just deleted it from all selected objects
			UpdateSelectedElement selectedElementLVIndex -- ok even if we deleted last item in list
					
			enableAccelerators = false
		) -- end, if selectedElementIndex  > 0
	) -- end, delete element button
	
	
	-- This event is called when the checkbox is checked
	on lvElements itemCheck hitItem do
	(
		hitItem.selected = true
		-- format "itemCheck % \n" hitItem.index
		closeSelectedElement()
		updateSelectedElement hitItem.index
		
		-- update the enable
		cElementEnable.checked = GetLvItemCheck lvElements selectedElementLVIndex
		enableSelectedElementGroup true 
		enableAccelerators = false
	)
	

	-- This event is called once an item is clicked
	on lvElements click do
	(
		enableAccelerators = false
		local sel = GetLvSelection lvElements 
		if sel != selectedElementLVIndex do
		(
			if _debug do format "click select: %; was: %\n" sel selectedElementLVIndex 
			closeSelectedElement()
			updateSelectedElement sel 	
		)
	)

	on lvElements keyup key shift do 
		if key == 38 or key == 40 do lvElements.click() -- 38 - up ; 40 down

	-- This event is called when a header is clicked
	on lvElements ColumnClick header do
	(
		if (lvElements.listItems.count > 1) then
		(	lvElements.sortkey = header.subItemIndex
			lvElements.sorted = true
			lvElements.sorted = false
			selectedElementLVIndex = lvElements.selectedItem.index
		)
		enableAccelerators = false
	)

	-------------------------------------------------
	-- On autoSized checked
	--
	on cAutoSz changed newState do
	(
		--	format "Set auto size: % \n" newState 
		enableSelectedElementGroup true
		UpdateAutoSize()
		if workingObjects.count == 1 then
			UpdateElementSz sWidth.value sHeight.value
		else
			UpdateElementSz undefined undefined
	)
	
	-------------------------------------------------
	-- On  element Enable checked
	--
	on cElementEnable changed _newState do
	(
		-- format "new: %, checked: % \n" (newState)(cElementEnable.checked)
		enableSelectedElementGroup true
		UpdateElementCheck cElementEnable.checked 	-- update listbox
	)

	-------------------------------------------------
	-- On find files button pressed
	--
	on bFindFile pressed do
	(
		-- format "find element file \n"
		local seed = eFileName.text
		if (getFilenamePath seed == "") then
		(
			-- no path, add default path
			seed = commonBakeProps.GetFilePath() + eFilename.text
		)
		
		-- this is the better way....allows setting extension specific params
		local f = selectSaveBitmap \
				caption:"Select Element File Name and Type" \
				filename:seed 
		
		if f != undefined then
		(								
			-- check for unique etc.
			f = CheckBakeElementFileName workingObjects[1].node selectedElement eName.text f (commonBakeProps.getFilePath())
			-- display it
			eFilename.text = f	
			UpdateElementFileName f
		)
	) -- end, on find files pressed


	-------------------------------------------------
	-- selected objects general properties
	--
	on sWidth changed newWidth do
	(
	--	format "Set Width: % \n" newWidth 
		cAutoSz.checked = false
		UpdateElementSz newWidth sHeight.value 
	)
	
	on sHeight changed newHeight do
	(
	--	format "Set Height: % \n" newHeight
		cAutoSz.checked = false
		UpdateElementSz sWidth.value newHeight
	)

	-------------------------------------------------
	-- element name changed
	--
	on eName entered newName do
	(
		if _debug do format "change element name: % \n" newName
		UpdateElementName newName
		if (selectedElement == undefined) or (workingObjects.count > 1) then
			return 0 -- dont update filename in this case
			
		saveName = selectedElement.elementName	-- save
		selectedElement.elementName = newName			-- replace
		newName = RTT_methods.MakeBakeElementFileName workingObjects[1].node selectedElement eFilename.text "" defaultFileType 
		selectedElement.elementName = saveName			-- restore
		if _debug do format "\tset filename: % \n" newName
		eFilename.text = newName
		UpdateElementFileName newName
	)
		
	-------------------------------------------------
	-- file name changed, see if it's an extension
	-- change or a name change
	--
	on eFileName entered newName do
	(
		-- eFileName enabled only if 1 node is selected
		f = CheckBakeElementFileName workingObjects[1].node selectedElement eName.text newName (commonBakeProps.getFilePath())
		eFilename.text = f	
		UpdateElementFileName f
	) -- end, on filename changed
	
	on dTargMapSlot selected val do
	(
		UpdateElementTargetMapName dTargMapSlot.selected
	)
	
	-- here's the size button handlers
	on bxsmall pressed do
	(
		sWidth.value = sHeight.value = mapPresets[1]
		cAutoSz.checked = false
		UpdateElementSz( sWidth.value )( sHeight.value )
	)
	on bsmall pressed do
	(
		sWidth.value = sHeight.value = mapPresets[2]
		cAutoSz.checked = false
		UpdateElementSz( sWidth.value )( sHeight.value )
	)
	on bmedium pressed do
	(
		sWidth.value = sHeight.value = mapPresets[3]
		cAutoSz.checked = false
		UpdateElementSz( sWidth.value )( sHeight.value )
	)
	on blarge pressed do
	(
		sWidth.value = sHeight.value = mapPresets[4]
		cAutoSz.checked = false
		UpdateElementSz( sWidth.value )( sHeight.value )
	)
	on bxlarge pressed do
	(
		sWidth.value = sHeight.value = mapPresets[5]
		cAutoSz.checked = false
		UpdateElementSz( sWidth.value )( sHeight.value )
	)
	on bxxlarge pressed do
	(
		sWidth.value = sHeight.value = mapPresets[6]
		cAutoSz.checked = false
		UpdateElementSz( sWidth.value )( sHeight.value )
	)

	-------------------------------------------------------
	-- functions to enable/disable groups of controls
	--
	-- the elementList group contains the list box & add & delete buttons
	function EnableElementListGroup _isEnabled _clearList =
	(
		if _debug do format "in selectedElementProps.EnableElementListGroup : group = %, clear = %\n" _isEnabled _clearList
		if _isEnabled == false then
			SelectLvItem lvElements 0
		lvElements.enabled = _isEnabled
		bAddElement.enabled = _isEnabled
		if _clearList then
		(	-- empty the list 
			lvElements.listItems.clear()
		)
	)
			
	-- enable UI elements in the selected elements group...
	function EnableSelectedElementGroup _isEnabled =
	(
		local enabled = _isEnabled
		cElementEnable.enabled = enabled 
		bDeleteElement.enabled = enabled 
		lbl1.enabled = enabled
		
		-- enable the rest based on enabled state for this element
		if allowControlDisable and cElementEnable.triState == 0 then
			enabled = false
			
		cAutoSz.enabled = enabled 
		eName.enabled = enabled 
		if not enabled do eName.text = ""

		l_targMapSlot.enabled = enabled 
		dTargMapSlot.enabled = enabled 
		
		if (workingObjects.count != 0) and ( selectedElement != undefined ) then
		(
			nParams = workingObjects[1].node.numElementParams selectedElement 
			EnableElementParams nParams enabled
		)
		
		--can't do filenames in multiple selections
		local fileEnable = enabled
		if workingObjects.count > 1 then
		 	fileEnable = false
			
		bFindFile.enabled = fileEnable 
		eFileName.enabled = fileEnable 
		if not fileEnable do eFileName.text = ""
	
		if cAutoSz.triState == 1 then
			enabled  = false				-- disable size controls on auto size
			
	 	sWidth.enabled = enabled 
		sHeight.enabled = enabled 
		bxsmall.enabled = enabled 
		bsmall.enabled = enabled 
		bmedium.enabled = enabled 
		blarge.enabled = enabled 
		bxlarge.enabled = enabled 
		bxxlarge.enabled = enabled 
	)
	
	function AddElementToList _on _fileName _eleName _szX _szY _target _tag=
	(
		local xStr, yStr 
			
		if _szX == undefined then xStr = "Varies" 
		else xStr = _szX as string
		if _szY == undefined then yStr = "Varies" 
		else yStr = _szY as string
		local size = xStr +"  x  "+ yStr
	
		AddLvItem lvElements #(_fileName,_eleName,size,_target) checked:_on tag:_tag -- returns listItem
	)
	
	function UpdateElementSz _szX _szY =
	(
		local xStr, yStr 
		if _szX == undefined then xStr = "Varies" 
		else xStr = _szX as string
		if _szY == undefined then yStr = "Varies" 
		else yStr = _szY as string
		local size = xStr +"  x  "+ yStr
		
		SetLvItemName lvElements selectedElementLVIndex 3 size
	)
	
	function UpdateElementName _eleName =
	(
		SetLvItemName lvElements selectedElementLVIndex 2 _eleName
	)
	
	function UpdateElementFileName _fileName =
	(
		SetLvItemName lvElements selectedElementLVIndex 1 _fileName
	)
	
	function UpdateElementTargetMapName _targetMapName =
	(
		SetLvItemName lvElements selectedElementLVIndex 4 _targetMapName 
	)
	
	
	function UpdateElementCheck _on =
	(
		if (selectedElementLVIndex > 0) and (selectedElementLVIndex <= lvElements.listItems.count) then
		(
			(lvElements.listItems[ selectedElementLVIndex ]).checked = _on
		) 
	)
		
	
	function UpdateElementList = 
	(
		if _debug do format "in selectedElementProps.UpdateElementList\n" 
		lvElements.listItems.clear()
		commonElements = #()
		commonElementsTargIndet = #{}
		
		if workingObjects.count > 0 then
		(
			if workingObjects.count > 1 then
			(
				local eleNames = #()
				local eleLists = #()

				-- multiple objects, find common elements
				for obj in workingObjects do
				(
					local bakeInterface = obj.node.INodeBakeProperties
					local nEles = bakeInterface.NumBakeElements()
					if _debug do format "\tnode: %; # effects: %\n" obj.node.name nEles
					
					-- for each ele of this object
					for i = 1 to nEles do
					(
						 local element = bakeInterface.GetBakeElement i
						 local match = false
						
						-- compare to current list
						local notFound = true
						local eleName = element.elementName
						local eleClass = classof element
						for j = 1 to eleNames.count while notFound do
						(	if eleNames[j] == eleName do
							(	-- name match, make sure class is same
								if classof eleLists[j][1].element == eleClass then
								( 	-- match
									--format "match ele :   %  = % \n" (element.elementName)(element as string)
									append (eleLists[ j ]) (bakeElementStruct element obj.node) -- add the ele to the list
									notFound = false
								)
							)
						)
						if notFound do -- no match
						(
							--format "no match, add ele :   %  \n" (element.elementName)
							append eleNames (element.elementName)
							eleLists[ eleNames.count ] = #(bakeElementStruct element obj.node) -- new list containing just ele
 							-- format "eles for % :   %  \n" (element.elementName) (eleLists[ eleNames.count ])
						)
						
					) --end, for each ele
				) -- end, for each object
					
				
				local grayColor = ((colorman.getColor #shadow)*255) as color
				grayColor = (color grayColor.b grayColor.g grayColor.r) -- this is the BGR thing...
				-- for each possible element	
				for i = 1 to eleNames.count do
				(
					local eleList = eleLists[ i ]	-- get ele's behind the common name
					
					-- for now, only common-to-all elements are shown
					if (not showCommonElementsOnly) or (eleList.count == workingObjects.count) then	
					(
						local isOn = triStateValue()
						local szX = triStateValue()
						local szY = triStateValue()
						local target = triStateValue()
						
						for e in eleList do
						(
							local ele = e.element
							isOn.setVal ele.enabled
							szX.setVal ele.outputSzX
							szY.setVal ele.outputSzY
							target.setVal ele.targetMapSlotName 
						)
						
						-- add bake element to listbox
						local index = lvElements.listItems.count+1
						commonElementsTargIndet[i]= target.indeterminate and target.defined
						target = if target.indeterminate then (if target.defined then "varies" else "" )
								 else target.value
						addElementToList isOn.value "" eleNames[i] szX.value szY.value target index
						if (not showCommonElementsOnly) and (eleList.count != workingObjects.count) do
							SetLvItemRowColor lvElements index grayColor
						
						-- copy the common elements behind the name
						commonElements[ index ] = eleList
						-- format "common elements[ % ] = % \n" (lvElements.listItems.count)(eleList)
						
					) --end, ele is common to all objects 
				) -- end, for each bake element
				
			) -- end, multiple selection
			else 
			(
	--->>>>>>	-- single object
				local obj = workingObjects[1].node
				local bakeInterface = obj.INodeBakeProperties
				local nEles = bakeInterface.NumBakeElements()
				if _debug do format "\tnode: %; # effects: %\n" obj.name nEles
				for i = 1 to nEles do
				(
					-- add bake element to listbox
					local element = bakeInterface.GetBakeElement i
					
					-- add bake element to listbox
					local isOn = if element.enabled then 1 else 0
					addElementToList isOn element.fileName element.elementName element.outputSzX element.outputSzY element.targetMapSlotName i
				
					-- copy the common elements to the common element lists
					commonElements[ i ] = #(bakeElementStruct element obj)
				
					-- format "common elements[ % ] = % \n" i commonElements[i]
				) -- end, for each bake element
			)-- end, single selection
				
		) -- end, some object selected
 
		-- reset the selection since we trashed the old element selection
		if _debug do format "\tcommonElementsTargIndet: %\n" commonElementsTargIndet 
		SelectLvItem lvElements 0
		lvElements.Refresh()		
	) -- end, update element list	

	-------------------------------------------------------
	-- function to close an element & update things in the
	-- element itself...not done on cancel
	-- called when switching elements in the list box &
	-- on Close for the last element
	-- NB: switching elements writes the changes with
	-- no cancel& no undo ...
	function CloseSelectedElement =
	(
		if _debug do format "close selected elements - selectedElement: %; selectedElementIndex: %\n" selectedElement selectedElementIndex
		
		if ( selectedElementIndex > 0 ) then
		(
			-- write to all objects
			local eleList = commonElements[ selectedElementIndex ]
			for e in eleList where isValidNode e.node do
			(
				local ele = e.element
				if _debug do format "Close Element: % \n" e -- eName.text 
				if( ele.elementName != eName.text ) then
				(
					ele.elementName = eName.text

					if (workingObjects.count > 1) then
					(	
						-- eFileName not enabled in this case. 
						-- regenerate filename, if unique returns same w/ possible frame#
						ele.fileName = RTT_methods.MakeBakeElementFileName e.node ele ele.fileName "" defaultFileType 
					)
					else
						ele.fileName = eFileName.text
				)
				else
				(
					if (workingObjects.count == 1) then
						ele.fileName = eFileName.text
				)

				-- don't write indeterminates!!
				if ( cElementEnable.triState != 2 ) then
					ele.enabled = cElementEnable.checked
						
				if ( cAutoSz.triState != 2 ) then
				(
					ele.autoSzOn = cAutoSz.checked 
					if ( not sHeight.indeterminate ) then
						ele.outputSzY = sHeight.value
					if ( not sWidth.indeterminate  ) then
						ele.outputSzX = sWidth.value
				)
				
				if _debug do format "\t% : % : %\n" dTargMapSlot.enabled commonElementsTargIndet[selectedElementIndex] dTargMapSlot.selection
				
				if dTargMapSlot.selection != 0 and dTargMapSlot.enabled and not (commonElementsTargIndet[selectedElementIndex] and dTargMapSlot.selection == 1) then 
				(
					ele.targetMapSlotName = dTargMapSlot.selected
				)
				if dTargMapSlot.selection != 0 and dTargMapSlot.enabled and dTargMapSlot.selection != 1 and not (commonElementsTargIndet[selectedElementIndex] and dTargMapSlot.selection == 2) then 
				(
					UpdateDefaultMtlMapSlotMapping e
				)
				
				-- save the optional params
				saveElementParams e
					
			) -- end, for each element
		) -- end, have selected element(s)
		
	) -- end, close selected element
	
	-------------------------------------------------------
	-- update the automatic element raster size 
	-- 
	function UpdateAutoSize =
	(
		--format "Update Auto Size, triState = % \n" ( cAutoSz.triState )
		if cAutoSz.triState == 1 then 	-- only "on", not for off or confused
		(
			--format "On Objects = %\n" workingObjects
			for curObj in workingObjects do
			(
				local myMesh = snapshotAsMesh curObj.node
				
				-- get the size from the mesh area
				local area = meshop.getFaceArea myMesh #all
				local nPix = 100 * (sqrt area) * commonBakeProps.sSizeScale.value 
				--format "Update size on object = % to size = % \n" (curObj as string) nPix
				
				-- powers of 2?
				if commonBakeProps.cSizePowersOf2.checked then 
				(
					-- modify size to closest power of 2
					local nPower = 0
					local n = nPix
					while n >= 2 do
					(
						n /= 2
						nPower += 1
					)
					-- nPix is between 2 to nPower & 2 to nPower+1, which is closer?
					if (nPix - 2 ^ nPower) <= (2 ^ (nPower+1) - nPix) then
						nPix = 2 ^ nPower
					else
						nPix = 2 ^ (nPower + 1)
				
				) -- end, power of 2
				
				-- bound it
				if nPix < commonBakeProps.sSizeMin.value then
					nPix = commonBakeProps.sSizeMin.value 
				if nPix > commonBakeProps.sSizeMax.value then
					nPix = commonBakeProps.sSizeMax.value 
					
				if( workingObjects.count > 1 ) and ( selectedElementIndex > 0 ) then
				(
					-- multiple selection, write to the object, no cancel
					local eleList = commonElements[selectedElementIndex]
					for e in eleList where (e.node == curObj.node) do
					(
						local ele = e.element
						--format "Close Element: % sz:  % \n" (ele)( nPix )
						ele.autoSzOn = true 
					
						ele.outputSzY = nPix
						ele.outputSzX = nPix
						--format "size set to % \n" (ele.outputSzX)
					)
					-- update the list box
					UpdateElementSz undefined undefined
				) 
				else 
				(
				 	-- single selection, just put in the spinners so cancel will work
					sWidth.value = sHeight.value = nPix
					-- update the list box
					UpdateElementSz sWidth.value sHeight.value
				)
				delete myMesh
				
			) -- end, for each object
			
			sWidth.indeterminate = sHeight.indeterminate = (workingObjects.count > 1)
			
		) -- end, autosize on	
	)

	-------------------------------------------------------
	-- update things when a new element in the bakeElement 
	-- list is selected. _newSelection is the list view index
	function UpdateSelectedElement _newSelection =
	(
		if _debug do format "in selectedElementProps.UpdateSelectedElement _newSelection: %\n" _newSelection
		
		local name, fName, isAutoSz, szX, szY, target, allTargetsForSelection
		local isOn = triStateValue()
		
		lbl_ElementType.caption = ""
		-- update the element params & enable
		if (_newSelection == 0) or (workingObjects.count == 0) \
			or (lvElements.listItems.count == 0) then
		(

			-- format "unselected element : %\n" (selectedElement as string)				
			-- nothing selected, disable all but delete button
			enableSelectedElementGroup false
				
			selectedElement = undefined
			selectedElementIndex = 0
			selectedElementLVIndex = 0
		)
		else 
		(
			-- an item of the listbox is selected, update & enable
			-- update the selected element display
			-- format "update selected element to: % , # % \n" (GetLvItemName lvElements _newSelection 1) _newSelection
			-- init the state vars
			isAutoSz = triStateValue()
			szX = triStateValue()
			szY = triStateValue()
			target = triStateValue()
			allTargetsForSelection = #()
			
			if _newSelection > commonElements.count then -- commonElements.count == lvElements.listItems.count, but quicker
				_newSelection = commonElements.count

			-- some object is selected, multiple?
			if (workingObjects.count > 1) then
			(
				-- multiple selection
				selectedElement = undefined
				selectedElementLVIndex = _newSelection
				selectedElementIndex = lvElements.listItems[selectedElementLVIndex].tag
	
				fName = "" -- no filename for multi selections
				name = GetLvItemName lvElements _newSelection 2

				-- see which params are in-common & which are not
				local eleList = commonElements[ selectedElementIndex ]
				for e in eleList do
				(
					local ele = e.element
					isOn.setVal ele.enabled
					isAutoSz.setVal ele.autoSzOn
					--format"		x = %, y = %. Accum x = %, Accum y = %\n" ele.outputSzX ele.outputSzY szX szY
					szX.setVal ele.outputSzX
					szY.setVal ele.outputSzY
					local target_name = ele.targetMapSlotName 
					target.setVal target_name
					if findItem allTargetsForSelection target_name == 0 do 
						append allTargetsForSelection target_name 
				) -- end, e is defined
				
				-- format"multi ele: % :: isOn = %\n" name isOn.value
			) -- end, multiple selection
			else 
			(
				-- single object selected
				selectedElementLVIndex = _newSelection
				selectedElementIndex = lvElements.listItems[selectedElementLVIndex].tag
				selectedElement = commonElements[ selectedElementIndex ][1].element

				isOn.setVal selectedElement.enabled
				isAutoSz.setVal selectedElement.autoSzOn
				szX.setVal selectedElement.outputSzX
				szY.setVal selectedElement.outputSzY
				local target_name = selectedElement.targetMapSlotName 
				target.setVal target_name 
				name = selectedElement.elementName
				fName = selectedElement.fileName
				allTargetsForSelection[1] = target_name

				-- format"single ele: % :: isOn = %\n" name isOn.value
			) -- end, else single selection		
		) -- end, list box item selected
			
		-- see if anything's been set up
		if isOn.defined then
		(
			-- update the dialog box UI
			-- do these before the group enable
			cElementEnable.triState = isOn.asTriState()
			cAutoSz.triState = isAutoSz.asTriState()
			enableSelectedElementGroup true 
			
			if szX.indeterminate then
				sWidth.indeterminate = true
			else
			(
				sWidth.indeterminate = false
				sWidth.value = szX.value
			)
			
			if szY.indeterminate then
				sHeight.indeterminate = true
			else
			(
				sHeight.indeterminate = false
				sHeight.value = szY.value
			)
				
			eName.text = name
			eFileName.text = fName

			-- make a list of all the map slot names in use by working objects other than those in 
			-- selected elements
			local usedMapSlots = #()
			local selectedElements = commonElements[ selectedElementIndex ]
			for eleList in commonElements where (eleList != selectedElements ) do
			(	for e in eleList do
				(
					local target_name = e.element.targetMapSlotName 
					if findItem usedMapSlots target_name == 0 do 
						append usedMapSlots target_name 
				) -- end, e 
			) -- end, eleList
			
			-- make a copy of the common map slots names
			local targetMapSlots = copy commonTargetMapSlots #nomap
			-- remove from list of common map slots names the names already in use other than by selected elements
			local index
			for target_name in usedMapSlots do
				if (index = findItem targetMapSlots target_name) != 0 do
					deleteItem targetMapSlots index 
			
			targetMapSlots = join #(" ") targetMapSlots
			if target.indeterminate do targetMapSlots = join #("varies") targetMapSlots 
			dTargMapSlot.items = targetMapSlots 
			if target.value == "" do target.value = " "
			if _debug do format "dTargMapSlot set: %\n" dTargMapSlot.items 
			if target.indeterminate then
			(
				dTargMapSlot.selection = 1
			)
			else
			(
				dTargMapSlot.selection = findItem targetMapSlots target.value
				if _debug do format "dTargMapSlot: % : % : %\n" dTargMapSlot.selection target.value targetMapSlots 
			)
			lbl_ElementType.caption = (classof selectedElements[1].element) as string
				
		) -- end, isOn not undefined
		
		-- put up the unique element params if any, clears old display
		makeElementParams()
		
		SelectLvItem lvElements selectedElementLVIndex
		
	) -- end, update selected element
		

	function CheckElementFileNames =
	(
		for obj_i in workingObjects do
		(	local obj = obj_i.node
			local bakeInterface = obj.INodeBakeProperties
			local nEles = bakeInterface.NumBakeElements()
					
			-- for each ele of this object
			for i = 1 to nEles do
			(
				local element = bakeInterface.GetBakeElement i
				local newName = RTT_methods.MakeBakeElementFileName obj element element.fileName "" defaultFileType 
				if (element.fileName != newName) do
				(
					if _debug do format "\tupdating element filename: node: %; element: %; old: %; new: %\n" obj.name element.elementName element.filename newname
					element.fileName = newName
				)
			)
		)
	)

	function CheckElementTargetMapNames =
	(
		for obj_i in workingObjects do
		(	local obj = obj_i.node
			local bakeInterface = obj.INodeBakeProperties
			local nEles = bakeInterface.NumBakeElements()
			local nodeTargMapNames = obj_i.mapSlotNames
					
			-- for each ele of this object
			for i = 1 to nEles do
			(
				local element = bakeInterface.GetBakeElement i
				local targMapName = element.targetMapSlotName
				if targMapName != "" and targMapName != " " and (findItem nodeTargMapNames targMapName) == 0 do 
				(
					if _debug do format "\tupdating element targetMapSlotName: node: %; element: %; old: %\n" obj.name element.elementName element.targetMapSlotName
					targMapName = element.targetMapSlotName = ""
				)
				
				if targMapName == "" and autoUpdateTargetMapSlotName do
				(
					local autoName = GetDefaultMtlMapSlotMapping (bakeElementStruct element obj)
					if (findItem nodeTargMapNames targMapName) == 0 then
						element.targetMapSlotName = ""
					else
						element.targetMapSlotName = autoName
				)
			)
		)
	)

	-----------------------------------------------------------------
	--
	--	Function to update Output rollout on a change in object selection
	--
	function OnObjectSelectionChange = 
	(
		if _debug do format "in selectedElementProps.OnObjectSelectionChange - workingObjects.count:%\n" workingObjects.count
		if workingObjects.count > 0 then
		(
			CheckElementFileNames()
			CheckElementTargetMapNames()
			UpdateElementList() 
			local lvItemCount = lvElements.listItems.count
			if (lvItemCount == 0) then
				selectedElementLVIndex = 0
			else
			(
				selectedElementLVIndex = if selectedElementLVIndex == 0 then 1 
										 else if selectedElementLVIndex > lvItemCount then lvItemCount
										 else selectedElementLVIndex
			)
			
			local targetMapNameList = for wo in workingObjects collect wo.mapSlotNames
			commonTargetMapSlots = CollectCommonElements targetMapNameList 
			if _debug do format "commonTargetMapSlots: %\n" commonTargetMapSlots 

			EnableElementListGroup true false
		)
		else 
		(
			-- count is 0. no object selection
			selectedElementLVIndex = 0
			-- disable list group & clear it
			EnableElementListGroup false true
		)-- end, no object selection
		
		-- update the selected element section in all cases
		UpdateSelectedElement selectedElementLVIndex 
		
		-- >>>>>>>>>
		if workingObjects.count > 0 then
			UpdateAutoSize()
	) -- end, update object selection

	-----------------------------------------------------------------------------------
	--
	--	set up the element parameter checkboxes
	--
	function MakeElementParams =
	(
		if _debug do format "makeElementParams - selectedElementIndex: %\n" selectedElementIndex 

		elementPropControls.enabled = false
		elementPropControls.visible = false
		
		if selectedElementIndex > 0 do 
		(
			-- get num params from any of the elements
			local eleList = commonElements[ selectedElementIndex ]
			local ele = eleList[1]	-- any of the eles is ok, just used to get nparams
			local element = ele.element
			
			local bakeInterface = ele.node.INodeBakeProperties
			local nParams = bakeInterface.numElementParams element
			if( nParams == 0 ) or ( nParams > maxNumElementParams ) then
				return 0
		 
			-- collect state on params
			local params = #()
			for i = 1 to nParams do params[i] = triStateValue()
			
			for e in eleList do
			(
				bakeInterface = e.node.INodeBakeProperties
				for n = 1 to nParams do
				(
					local val = bakeInterface.paramValue e.element n
					params[n].setVal ( val > 0 )
					
				) -- end, for each param
			) -- end, for each element
			
			--format "make % element param rollup \n" nParams
			for i = 1 to nParams do
			(
				local cb = elementPropControls[i]
				cb.triState = params[i].asTriState()
				cb.caption = bakeInterface.paramName element i
				cb.enabled = true
				cb.visible = true
			)
		) -- end if selectedElementIndex > 0 
	) -- end function MakeElementParams 
	
	
	-----------------------------------------------------------------------------------
	--
	--	save the variable params. Passed in a bakeElementStruct 
	--
	function SaveElementParams _element = 
	(
		local bakeInterface = _element.node.INodeBakeProperties
		local ele = _element.element
		--	format "save % w/ nParams = %\n"  ele.elementName ( bakeInterface.numElementParams ele )
		local nParams = bakeInterface.numElementParams ele
		for i = 1 to nParams do
		(
			local val = elementPropControls[i].triState
			if val < 2 do -- only write un-confused values
				 bakeInterface.setParamValue ele i val
		)
	) -- end, save element params
	
	
	-----------------------------------------------------------------------------------
	--
	--	enable the variable param rollup
	--
	function EnableElementParams _nParams _enable =
	(
		--format "enable % unique params to %\n" _nParams _enable
		for i = 1 to _nParams do
			elementPropControls[i].enabled = _enable
	) -- end, enable element params
	
	function ReadConfigData =
	(
		cAutoSz.checked = 	RTT_data.OutputMapSize_AutoMapSize
		sWidth.value = 		RTT_data.OutputMapSize_Width
		sHeight.value = 	RTT_data.OutputMapSize_Height
		
	) -- end fn ReadConfigData 
	
	function WriteConfigData =
	(
		RTT_data.OutputMapSize_AutoMapSize = cAutoSz.checked 
	 	RTT_data.OutputMapSize_Width = sWidth.value
	 	RTT_data.OutputMapSize_Height = sHeight.value
		
	) -- end fn WriteConfigData 

) -- end, selected element props

rollout bakedMtlProps "Baked Material"
(
	-- local functions
	local ReadConfigData, WriteConfigData
	local availBakedMtTypes -- contain RTT_MlTypes struct instances
	local lastNewBakedType_index
	
	group "Baked Material Settings"
	(	radiobuttons rbDestination labels:#("Output Into Source","Save Source (Create Shell)") offset:[-5,-3] align:#left  columns:1
		radiobuttons rbShellOption labels:#("Duplicate Source to Baked","Create New Baked") align:#left offset:[10,-3] columns:1
		dropdownlist dNewBakedType "" enabled:true width:275 align:#left offset:[28,-3]
	)
	button bUpdateMtls "Update Baked Materials" across:2
	button bClearShellMtls "Clear Shell Materials"
	checkbox cbRenderToFilesOnly "Render to Files Only"
	
	on cbRenderToFilesOnly changed state do
	(
		-- don't disable. Target Map Slots depend on these settings, so need to change even
		-- if not immediately baking to mtl.
		-- rbDestination.enabled = not state
		-- rbShellOption.enabled = (not state) and rbDestination.state == 2
	)
	on rbDestination changed state do
	(
		rbShellOption.enabled = (state == 2)
		if (rbShellOption.state == 2) then -- this results in change in available target map slot names
		(
			selectedElementProps.CloseSelectedElement() -- accept changes on working elements
			for wo in workingObjects do 
				wo.mapSlotNames = CollectTargetMapNamesForNode wo.node
			selectedElementProps.OnObjectSelectionChange()
			dNewBakedType.enabled = (state == 2)
		)
		else
			dNewBakedType.enabled = false
	)
	on rbShellOption changed state do
	(
		-- this results in change in available target map slot names
		selectedElementProps.CloseSelectedElement() -- accept changes on working elements
		for wo in workingObjects do 
			wo.mapSlotNames = CollectTargetMapNamesForNode wo.node
		selectedElementProps.OnObjectSelectionChange()
		dNewBakedType.enabled = (state == 2)
	)
	on dNewBakedType selected index do
	(
		-- this results in change in available target map slot names
		selectedElementProps.CloseSelectedElement() -- accept changes on working elements
		newBakedMtlInstance = availBakedMtTypes[index].instance
		newBakedMtlTargetMapNames = CollectTargetMapNamesForMtl newBakedMtlInstance
		if _debug do format "newBakedMtlTargetMapNames: %\n" newBakedMtlTargetMapNames 
		for wo in workingObjects do 
			wo.mapSlotNames = CollectTargetMapNamesForNode wo.node
		selectedElementProps.OnObjectSelectionChange()
		lastNewBakedType_index = index
	)
	on bUpdateMtls pressed do
	(
		UpdateBakedMtls workingObjects
	)
	on bClearShellMtls pressed do
	(
		RemoveBakeMaterials()	
	)
	on bakedMtlProps open do
	(
		ReadConfigData()
		cbRenderToFilesOnly.enabled =(not commonBakeProps.cNetworkRender.checked) -- disable if network render chosen
		availBakedMtTypes = CollectMtlTypes()
		local availBakedMtTypeNames = for m in availBakedMtTypes collect m.name
		dNewBakedType.items = availBakedMtTypeNames
		local i = 1
		local notFound = true
		for j = 1 to availBakedMtTypes.count while notFound do
			if classof availBakedMtTypes[j].instance == StandardMaterial and ((availBakedMtTypes[j].instance.shaderByName as name) == defaultMtlShader) do
			(	i = j
				notFound = false
			)
		dNewBakedType.selection = i
		rbShellOption.enabled = (rbDestination.state == 2)
		dNewBakedType.enabled = (rbShellOption.state == 2) and (rbDestination.state == 2)
		newBakedMtlInstance = availBakedMtTypes[i].instance
		lastNewBakedType_index = index
		newBakedMtlTargetMapNames = CollectTargetMapNamesForMtl newBakedMtlInstance
		if _debug do format "newBakedMtlTargetMapNames: %\n" newBakedMtlTargetMapNames 
	)
	on bakedMtlProps close do
	(
		WriteConfigData()
	)
	
	function ReadConfigData =
	(
		cbRenderToFilesOnly.checked = 	RTT_data.Materials_RenderToFilesOnly
		rbDestination.state = 			RTT_data.Materials_MapDestination
		rbShellOption.state = 			RTT_data.Materials_DuplicateSourceOrCreateNew
	)

	function WriteConfigData =
	(
		RTT_data.Materials_RenderToFilesOnly = cbRenderToFilesOnly.checked
		RTT_data.Materials_MapDestination = rbDestination.state
		RTT_data.Materials_DuplicateSourceOrCreateNew = rbShellOption.state
	)
	
) -- end - rollout bakedMtlProps

------------------------------------------------------------------
--
--	Create the gTextureBakeDialog dialog & assign the subrollouts
--	
on execute do with undo off
(
	local cls = classof gTextureBakeDialog;
	if ((cls == RolloutClass) and (gTextureBakeDialog.placement == #minimized)) do
	(
		gTextureBakeDialog.placement = #normal
		return()
	)

	-- re-initialize locals
	selectedObjects = #() -- the selected objects. Contains nodes
	displayedBakableObjects = #() -- the selected objects that are bakable. Contains bakableObjStruct instances
	workingObjects = #() -- the current working objects. Contains bakableObjStruct instances

	-- one time init on new session. Session persistent defaults go here.
	if (RTT_data == undefined) do
	(
		RTT_data = RTT_data_struct()

		RTT_data.overwriteFilesOk = 0

		RTT_data.FileOutput_FileType = ".tga"
		RTT_data.FileOutput_FilePath = getdir #image
		
		RTT_data.AutoFlatten_On = true
		RTT_data.AutoFlatten_Spacing = 0.03
		RTT_data.AutoFlatten_ThresholdAngle = 45.0
		RTT_data.AutoFlatten_Rotate = true
		RTT_data.AutoFlatten_FillHoles = true
		RTT_data.AutoFlatten_MapChannel = 3
		
		RTT_data.AutoSize_SizeMin = 32
		RTT_data.AutoSize_SizeMax = 2048
		RTT_data.AutoSize_SizeScale = 0.01
		RTT_data.AutoSize_SizePowersOf2 = false 
		
		RTT_data.Renderer_DisplayFB = true
		RTT_data.Renderer_NetworkRender = false
		RTT_data.Renderer_SkipExistingFiles = false
		
		RTT_data.OutputMapSize_AutoMapSize = false 
		RTT_data.OutputMapSize_Width = mapPresets[1]
		RTT_data.OutputMapSize_Height = mapPresets[1]
		
		RTT_data.Materials_RenderToFilesOnly = false
		RTT_data.Materials_MapDestination = 2
		RTT_data.Materials_DuplicateSourceOrCreateNew = 1
		
		RTT_Data.Dialog_CommonBakeProps_Open = true
		RTT_Data.Dialog_SelectedObjectProps_Open = true
		RTT_Data.Dialog_SelectedElementProps_Open = true
		RTT_Data.Dialog_BakedMtlProps_Open = true

		RTT_Data.rendererErrorDisplayed = false
		RTT_Data.netRenderErrorDisplayed = false
	)

	ReadDialogConfig()
	
	CreateDialog gTextureBakeDialog \
		style:#(#style_sysmenu,#style_titlebar,#style_minimizebox,#style_resizing) \
		pos:pDialogPos lockWidth:true
		
	--format "setting height = % \n" pDialogHeight
	gTextureBakeDialog.height = pDialogHeight
	gTextureBakeDialog.width = 350

	AddSubRollout gTextureBakeDialog.rollouts commonBakeProps rolledup:(not RTT_Data.Dialog_CommonBakeProps_Open)
	AddSubRollout gTextureBakeDialog.rollouts selectedObjectProps rolledup:(not RTT_Data.Dialog_SelectedObjectProps_Open)
	AddSubRollout gTextureBakeDialog.rollouts selectedElementProps rolledup:(not RTT_Data.Dialog_SelectedElementProps_Open)
	AddSubRollout gTextureBakeDialog.rollouts bakedMtlProps rolledup:(not RTT_Data.Dialog_BakedMtlProps_Open)
	
	-- & use initial node selection
	gTextureBakeDialog.OnObjectSelectionChange()

	local errormsg = ""
	if (not RTT_Data.rendererErrorDisplayed and not renderers.current.supportsTexureBaking) do 
	(
		errormsg = "Renderer doesn't support Texture Baking, Rendering disabled\n"
		RTT_Data.rendererErrorDisplayed = true
	)
	if (not RTT_Data.netRenderErrorDisplayed and classof netrender != Interface) do 
	(	
		errormsg += "Backburner interface not found - network rendering disabled\n"
		RTT_Data.netRenderErrorDisplayed = true
	)
	if errormsg != "" do messagebox errormsg 
)

on isEnabled return (local cls = classof gTextureBakeDialog;(cls != RolloutClass) or (not gTextureBakeDialog.open) or (cls == RolloutClass) and (gTextureBakeDialog.placement == #minimized))
on isChecked return ((classof gTextureBakeDialog == RolloutClass) and gTextureBakeDialog.open)

) -- end, macroscript BakeDialog
