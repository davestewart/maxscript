/*
UI Scheme Macros

Revision History:

Oct 25 2001; Max 4 implementation

August 14 2003; Pierre-Felix Breton
	Max 6 modifications/refactoring of functions
	Added UI/Defaults switcher Macro
	Added localization comments and cleaned code comments


August 19 2003;Pierre-Felix Breton
	removed hardcoded refs to the 3dsmax.ini file
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
*/

---------------------------------------------------------------------------------------------------
/*
CUI and Defaults switcher

Provide a choice to select the market specific toolbar and defaults settings.

Save this choice for subsequent launches by:
	-changing the 3dsmax.ini file to point to the desired defaults settings folder
	-saving a MaxStartUI.cui file and loading the desired CUI file set (this is identical to the Load Custom UI scheme command in MAX)


Dependencies:

--hardcoded dependency on the following folder/files names:

	\defaults\MAX\
	\defaults\DesignVIZ\
	\UI\DefaultUI.* (*.ui, *.cui, *.mnu, *.clr) etc
	\UI\MaxstartUI.CUI\
	\html\cui.defaults.switcher\*.html


-functions defined in the [maxinstall]/stdplugs/scripts/customUIschemes_functions.ms

*/
---------------------------------------------------------------------------------------------------


MacroScript CustomUISchemeDefaultsSwitcher 
category:"Customize User Interface" 
internalcategory:"Customize User Interface" 
tooltip:"Custom UI and Defaults Switcher" 
ButtonText:"Custom UI and Defaults Switcher"
SilentErrors:(Debug != True)
(


	--decalres variables
	local rlt_main
	local rlt_size
	local axMargin
	local ctrlMargin
	local topUIMargin
	local botUIMargin
	local btnWidth
	local btnHeight
	local strWebDocPath
-------------------------------------------------------------------------
--  getCUISchemesList 

-- function that parses the [maxinstall]\ui folder 
-- to obtain the list of ui schemes (defined by the *.ui extension)
-- returns an array containing the list of UI schemes
------------------------------------------------------------------------------
fn getCUISchemesList = 
(
	local arStrUISchemesFnames = #()
	local i, j
	arStrUISchemesFnames = getFiles ((getdir #UI) + "\\*.ui")

	j = 0
	for i in arStrUISchemesFnames do
	(
		j = j + 1
		local strFname  = getFileNameFile i

		--skip the startup.ui bak file: the fact that this file is ending by ".ui" is a bug and really, it should be ".cui"
		-- this may be resolved in the future but we add this extra security for now, to avoid confusion
		if strFname == "_startup" --LOC_NOTES: do not localize this
			then deleteItem arStrUISchemesFnames j
			else arStrUISchemesFnames[j] = strFname 
	)
	
	--re arrange the list so the DefaultUIs we ship are always on top of the list (first in the array), to make this easier to non-educated users, as per design decision
	--if they disappear from the builds in next releases or renammed, theses lines of code will simply do nothing
	local intArIndex = 0

	intArIndex  = findItem arStrUISchemesFnames "DefaultUI" --LOC_NOTES: do not localize this
	if intArIndex  != 0 do 
	(
		deleteItem arStrUISchemesFnames intArIndex  
		insertItem "DefaultUI" arStrUISchemesFnames 1 --LOC_NOTES: do not localize this
	)

	intArIndex  = findItem arStrUISchemesFnames "ModularToolbarsUI" --LOC_NOTES: do not localize this
	if intArIndex  != 0 do 
	(
		deleteItem arStrUISchemesFnames intArIndex  
		insertItem "ModularToolbarsUI" arStrUISchemesFnames 2 --LOC_NOTES: do not localize this
	)	
	
	intArIndex  = findItem arStrUISchemesFnames "discreet-light" --LOC_NOTES: do not localize this
	if intArIndex  != 0 do 
	(
		deleteItem arStrUISchemesFnames intArIndex  
		insertItem "discreet-light" arStrUISchemesFnames 3 --LOC_NOTES: do not localize this
	)

	intArIndex  = findItem arStrUISchemesFnames "discreet-dark" --LOC_NOTES: do not localize this
	if intArIndex  != 0 do 
	(
		deleteItem arStrUISchemesFnames intArIndex  
		insertItem "discreet-dark" arStrUISchemesFnames 4 --LOC_NOTES: do not localize this
	)		
	arStrUISchemesFnames --returns the array of string
	
)--end function

-------------------------------------------------------------------------------------------
--  getDefaultsList 

-- function that parses the [maxinstall]\defaults folder 
-- to obtain the list of defaults schemes (defined by foldersnames)

-- returns an array containing the of the Defaults names
-------------------------------------------------------------------------------------------
fn getDefaultsList = 
(
	local arStrDefaultsFoldNames = #()
	local i, j
	arStrDefaultsFoldNames = getDirectories ((getdir #maxroot) + "defaults\\*") --LOC_NOTES: do not localize this

	--removes the path info from the folder names
	j = 0
	for i in arStrDefaultsFoldNames do
	(
		j = j + 1
		local arStrSplitFoldNames = #() 
		arStrSplitFoldNames  = filterstring i "\\" 
		arStrDefaultsFoldNames[j] = arStrSplitFoldNames[arStrSplitFoldNames.count]
	)
	
	--re arrange the list so the Defaults we ship are always on top of the list (first in the array), to make this easier to non-educated users, as per design decision
	--if they disappear from the builds in next releases or renammed, theses lines of code will simply do nothing
	local intArIndex = 0
	intArIndex  = findItem arStrDefaultsFoldNames "MAX" --LOC_NOTES: do not localize this

	if intArIndex  != 0 do 
	(
		deleteItem arStrDefaultsFoldNames intArIndex  
		insertItem "Max" arStrDefaultsFoldNames 1 --LOC_NOTES: do not localize this
	)
	
	intArIndex  = findItem arStrDefaultsFoldNames "MAX.mentalray" --LOC_NOTES: do not localize this

	if intArIndex  != 0 do 
	(
		deleteItem arStrDefaultsFoldNames intArIndex  
		insertItem "Max.mentalray" arStrDefaultsFoldNames 2 --LOC_NOTES: do not localize this
	)
	
	intArIndex  = findItem arStrDefaultsFoldNames "DesignVIZ" --LOC_NOTES: do not localize this

	if intArIndex  != 0 do 
	(
		deleteItem arStrDefaultsFoldNames intArIndex  
		insertItem "DesignVIZ" arStrDefaultsFoldNames 3 --LOC_NOTES: do not localize this
	)
	
	intArIndex  = findItem arStrDefaultsFoldNames "DesignVIZ.mentalray" --LOC_NOTES: do not localize this

	if intArIndex  != 0 do 
	(
		deleteItem arStrDefaultsFoldNames intArIndex  
		insertItem "DesignVIZ.mentalray" arStrDefaultsFoldNames 4 --LOC_NOTES: do not localize this
	)
	
	arStrDefaultsFoldNames
	
)--end function


		
on execute do
(

	--init variables
	
	rlt_size = point2 700 650
	axMargin = 30
	ctrlMargin = 30
	topUIMargin = 110
	botUIMargin = 50
	btnWidth = 100
	btnHeight = 25
	strWebDocPath = (getdir #maxroot + "html\\cui.defaults.switcher\\") -- LOC_Notes: do not localize this
	
	
	---------------------------------------------------------------------------------------------------------------
	-- Rollout UI
	---------------------------------------------------------------------------------------------------------------
	
	rollout rlt_main "Choose initial settings for tool options and UI layout." -- LOC_Notes: localize this
	(
		
		--ui section
		listbox lstBoxCUI "UI schemes:" items:#() height:5 \ -- LOC_Notes: localize this
			pos:[(rlt_size.x/2 + ctrlMargin/2), ctrlMargin/2] \	
			width:(rlt_size.x/2 - ctrlMargin) 
		
		listbox lstBoxDefaults "Initial settings for tool options:" items:#() height:5 \ -- LOC_Notes: localize this
			pos:[ctrlMargin/2, ctrlMargin/2] \
			width:(rlt_size.x/2 - ctrlMargin)
	
		--documentation, active x
		activeXControl ax "{8856F961-340A-11D0-A96B-00C04FD705A2}"  \ --LOC_Notes: do not localize this
			pos:[(axMargin/2),(axMargin/2 + topUIMargin)] \
			width:(rlt_size.x - axMargin) \
			height:(rlt_size.y-axMargin-topUIMargin-botUIMargin) 
	
		--ok cancel help buttons
		button btnCancelDialog "Cancel" width:btnWidth height:btnHeight \ -- LOC_Notes: localize this
			pos:[(rlt_size.x-ctrlMargin/2-btnWidth), (rlt_size.y-botUIMargin/2-btnHeight/2)] \
			enabled:true
	
		button btnOkDialog "Set" width:btnWidth height:btnHeight \ -- LOC_Notes: localize this
			pos:[(rlt_size.x-ctrlMargin-2*btnWidth), (rlt_size.y-botUIMargin/2-btnHeight/2)] \
			enabled:true
			
		button btnHelpDialog "<<" width:(btnWidth/2) height:btnHeight \ -- LOC_Notes: localize this
			pos:[(ctrlMargin/2), (rlt_size.y-botUIMargin/2-btnHeight/2)] \
			enabled:false
			
		--//////////////////////////////////////////////////////////////////////////////
	    --Rollout Events
	    --//////////////////////////////////////////////////////////////////////////////
	
		on rlt_main open do
		( 
			
			enableAccelerators = false
			
			--sets the webpage welcome html file
			if (doesFileExist (strWebDocPath + "index.html")) == true do ax.navigate (strWebDocPath + "index.html") --LOC_Notes: do not localize this
	
			--populates the listboxes
			lstBoxCUI.items = getCUISchemesList()
			lstBoxDefaults.items = getDefaultsList()

			-- selects the first item in the CUI scheme list
			lstBoxCUI.selection = 1
			
			
			--selects the current set of defaults in the Defaults list
			--compares the list of items with the current defaults and highlight the currently active defaults set
			
				--extract the name of the defaults set from the defaults folder path
				local strCurrentDefaults
				local arStrSplitFoldNames = #() 
				arStrSplitFoldNames  = filterstring (getdir #defaults) "\\" 
				strCurrentDefaults = (arStrSplitFoldNames[arStrSplitFoldNames.count])
				
				--compares with the list
				local i
				local index = 0
				local j = 0
				for i in lstBoxDefaults.items do
				(
					j = j + 1
					if (matchpattern strCurrentDefaults  pattern:i ignorecase:true) do index = j
				)	
				lstBoxDefaults.selection = index
				
		)
		
		on rlt_main resized size do
		(
			--resizes the list box controls
			--lstBoxCUI.pos = [ctrlMargin/2, ctrlMargin/2]
			--lstBoxDefaults.pos = [(size.x/2 + ctrlMargin/2), ctrlMargin/2]
	
			--lstBoxCUI.width = (size.x/2-ctrlMargin)
			--lstBoxDefaults.width = (size.x/2-ctrlMargin)
		
			-- resize the browser control
			ax.size = [(size.x - axMargin),(size.y-axMargin-topUIMargin-botUIMargin)]
	
			--repositions the Set/Cancel buttons
			btnCancelDialog.pos = [(size.x-ctrlMargin/2-btnWidth), (size.y-botUIMargin/2-btnHeight/2)]
			btnOkDialog.pos = [(size.x-ctrlMargin-2*btnWidth), (size.y-botUIMargin/2-btnHeight/2)]
			btnHelpDialog.pos = [ctrlMargin/2, (size.y-botUIMargin/2-btnHeight/2)]
			
		)
		
		on lstBoxDefaults selected item do
		(
			--set the webpage browser to show the corresponding html file for better explanations
			local strFldName = ""
			strFldName = (strWebDocPath + "defaults." + lstBoxDefaults.selected +".html") --LOC_Notes: do not localize this
			
			if (doesFileExist strFldName) == true
			then ax.navigate strFldName  --LOC_Notes: do not localize this
			else
				(
					if (doesFileExist (strWebDocPath + "defaults.unknown.entry.html") == true) do ax.navigate (strWebDocPath + "defaults.unknown.entry.html") --LOC_Notes: do not localize this
				)
			
			-- enables the set button only if the 2 list boxes are set to a given selection
			if (lstBoxCUI.selection != 0 and lstBoxDefaults.selection != 0) do btnHelpDialog.enabled = true
		)
		
		
		on lstBoxCUI selected item do
		(
			--set the webpage browser to show the corresponding html file for better explanations
			local strFldName = ""
			strFldName = (strWebDocPath + "ui." + lstBoxCUI.selected +".html") --LOC_Notes: do not localize this
			
			if (doesFileExist strFldName) == true
			then ax.navigate strFldName  --LOC_Notes: do not localize this
			else
				(
					if (doesFileExist (strWebDocPath + "ui.unknown.entry.html") == true) do ax.navigate (strWebDocPath + "ui.unknown.entry.html") --LOC_Notes: do not localize this
				)
			
			-- enables the set button only if the 2 list boxes are set to a given selection
			if (lstBoxCUI.selection != 0 and lstBoxDefaults.selection != 0) do btnHelpDialog.enabled = true
		)
		
		
		on btnCancelDialog pressed do destroyDialog(rlt_main)
		
		on btnHelpDialog pressed do 
		(
			--sets the webpage welcome html file
			if (doesFileExist (strWebDocPath + "index.html")) == true do ax.navigate (strWebDocPath + "index.html") --LOC_Notes: do not localize this
		)
		
		on btnOkDialog pressed do 
		( 		
			--loads the selected options as UI	
			if lstBoxCUI.selected != undefined do loadCUIScheme ((getdir #ui) + "\\" + lstBoxCUI.selected + ".ui")
			
			--loads selected options as Market defaults
			if lstBoxDefaults.selected != undefined do 
			(	
				setIniSetting (GetMAXIniFile()) "Directories" "Defaults" ((getdir #maxroot) + "defaults\\"+ lstBoxDefaults.selected) --LOC_NOTES: do not localize this
				messagebox "The Defaults settings will take effect the next time you restart 3ds max." title:"Custom UI and Defaults Switcher" -- LOC_Notes: localize this
			)
	
			--finishes the job
			destroyDialog(rlt_main)
		)
			
	)--end rollout
	
	
	createDialog rlt_main rlt_size.x rlt_size.y \
	modal:false style:#(#style_resizing, #style_titlebar,  #style_border)


)--end on execute

)--end macro



---------------------------------------------------------------------------------------------------
/*
LoadScheme

Allows users to load UI schemes and icon directories. 
The current design forces all UI files to be in the [maxinstall]/ui/ directory

This macro is dependant on:

-functions defined in the [maxinstall]/stdplugs/scripts/customUIschemes_functions.ms

*/
---------------------------------------------------------------------------------------------------


MacroScript LoadScheme 
	category:"Customize User Interface" 
	internalcategory:"Customize User Interface" 
	tooltip:"Load Custom UI Scheme" 
	ButtonText:"Load Custom UI Scheme"
	SilentErrors:(Debug != True)
	(
		
		on execute do
		(
			-- Default Directory and Filename "DefaultUI"
			local DirectorySeed = getdir(#UI)+"\\DefaultUI.ui" --LOC_Notes: do not localize this
			
			-- Disable Esacpe Key
			EscapeEnable=false	
			
			--loads the UI scheme (function defined in the [maxinstall]/stdplugs/scripts/customUIschemes_functions.ms)			
			UIScheme_Filename = getOpenFilename filename:DirectorySeed caption:"Load Custom UI Scheme" \
				types:"Scheme (*.ui)|*.ui|Color File(*.clr)|*.clr|UI File(*.cui)|*.cui|Menu File(*.mnu)|*.mnu|Shortcuts File(*.kbd)|*.kbd|Quad Options File(*.qop)|*.qop" --LOC_Notes: localize this
				
			loadCUIScheme UIScheme_Filename
			
			-- Enable ESC Key
			EscapeEnabled = true
		)-- end execute

	)--end MacroScript LoadScheme





---------------------------------------------------------------------------------------------------
/*
SaveScheme
Allows users to save UI schemes and icon directories. 

The current design forces all UI files to be in the [maxinstall]/ui/ directory

This macro is dependant on:

-functions defined in the [maxinstall]/stdplugs/scripts/customUIschemes_functions.ms
*/
---------------------------------------------------------------------------------------------------



MacroScript SaveScheme 
category:"Customize User Interface" 
internalcategory:"Customize User Interface" 
tooltip:"Save Custom UI Scheme" 
ButtonText:"Save Custom UI Scheme"
SilentErrors:(Debug != True)
(

local UIScheme_Directories_Names, UIScheme_Directories_Name, UIScheme_Bitmap_Preview, UIScheme_Filename

on execute do
(

	
		
		-------------------------------------
		-- Get filename from Save dialog
		-- known limitation:  there is no way to know if a given *.ui file is active or not
		-- because a UI scheme is split in multiple files, you can't tell if they are all loaded
		-- or not.  Our best luck is to assume that yes and rely on the current CUI file
		-------------------------------------
		local strfpath = cui.getConfigFile()
		local DirectorySeed =  getfilenamepath(strfpath) + getfilenamefile(strfpath) + ".ui"
		
		-------------------------------------
		-- Set types of files to load
		-------------------------------------
		
		UIScheme_Filename = getSaveFilename filename:DirectorySeed \
			caption:"Save Custom UI Scheme" \ --LOC_Notes: localize this
			types:"Interface Scheme(*.ui)|*.ui|UI File(*.cui)|*.cui|Menu File(*.mnu)|*.mnu|Color File(*.clr)|*.clr|Shortcut File(*.kbd)|*.kbd|" --LOC_Notes: localize this

		If UIScheme_Filename != undefined do
		(
			rollout SaveDialog "Custom Scheme" width:240 height:224 --LOC_Notes: localize this
			(
				local UIScheme_Icon_Setup, SaveSchemeName, UIScheme_IconRoll 
				button go "OK" pos:[8,192] width:64 height:24 --LOC_Notes: localize this
				
				button BtnCancel "Cancel" pos:[168,192] width:64 height:24 --LOC_Notes: localize this
				checkbox ChkCUI "Interface Layout (.cui)" pos:[24,24] width:128 height:16 checked:true --LOC_Notes: localize this
				button AllOptions "All" pos:[176,24] width:56 height:16 --LOC_Notes: localize this
				button BtnNone "None" pos:[176,48] width:56 height:16 --LOC_Notes: localize this
				checkbox ChkKBD "Keyboard Shortcuts (.kbd)" pos:[24,48] width:144 height:16 checked:true --LOC_Notes: localize this
				checkbox ChkMNU "Menus (.mnu)" pos:[24,72] width:144 height:16 checked:true --LOC_Notes: localize this
				checkbox ChkQOP "Quad Options (.qop)" pos:[24,96] width:144 height:16 checked:true --LOC_Notes: localize this
				checkbox ChkCLR "Colors (.clr)" pos:[24,120] width:144 height:16 checked:true --LOC_Notes: localize this
				
				radioButtons RadioIcon "" pos:[112,144] width:119 height:32 labels:#("Classic", "2D Black and White") columns:1 --LOC_Notes: localize this
				label lbl3 "Icon Type:" pos:[32,152] width:56 height:16 --LOC_Notes: localize this
				
				
				on go pressed do
				(
					SaveSchemeName = GetFileNameFile UIScheme_Filename	
					SaveSchemePath = GetFileNamePath UIScheme_Filename
			
					if ChkMNU.state == true do MenuMan.saveMenuFile 		(SaveSchemePath + SaveSchemeName +".mnu")
					if ChkCLR.state == true do ColorMan.saveColorFIle 		(SaveSchemePath + SaveSchemeName +".clr" )
					if ChkKBD.state == true do ActionMan.saveKeyboardFile 	(SaveSchemePath + SaveSchemeName +".kbd" )
					if ChkCUI.state == true do Cui.saveConfigAs 			(SaveSchemePath + SaveSchemeName +".cui")
						
						----------------------------------------------------------------------------	
						-- Save CUI file as startup so your changes are loaded when restarting MAX
						----------------------------------------------------------------------------	
				
					if ChkCUI.state == true do cui.saveConfigAs ("MaxStartUI.cui") --LOC_Notes: do not localize this
						
						----------------------------------------------------------------------------	
						-- Saves Quad Colors into a MAXScript file in your UI directory with .qop extention
						----------------------------------------------------------------------------	
						
					if ChkQOP.state == true do SaveQuadClr SaveSchemePath SaveSchemeName ".qop" (UIScheme_Filename + " Scheme") --LOC_Notes: do not localize this
					
						----------------------------------------------------------------------------	
						-- Save a dat file that points to the right icon directory
						----------------------------------------------------------------------------	
	
					local strUIFilePath = (SaveSchemePath + SaveSchemeName + ".ui")
					local fAttrib = false
					if doesFileExist (strUIFilePath) do fAttrib = getFileAttribute strUIFilePath #readonly
					
					if RadioIcon.state == 1 do
						(
						if fAttrib == false 
						then 
						(
							UIScheme_Icon_Setup = CreateFile (strUIFilePath)
							Format "Icons" to:UIScheme_Icon_Setup --LOC_Notes: do not localize this
							Close UIScheme_Icon_Setup
						)
						else
						(
							local str = "Error saving " + strUIFilePath + "\n (The file may be read only.)\n\n UI Scheme Icons Folder Not Saved." --LOC_NOTES: localize this
							messagebox str title:"Error" --LOC_NOTES: localize this
						)-- end if UIScheme_Icon_Setup != undefined 
					)
					if RadioIcon.state == 2 do
					(
						if fAttrib == false 
						then 
						(
							UIScheme_Icon_Setup = CreateFile (strUIFilePath)
							Format "discreet" to:UIScheme_Icon_Setup --LOC_Notes: do not localize this
							Close UIScheme_Icon_Setup
						)
						else
						(
							local str = "Error saving " + strUIFilePath +  "\n (The file may be read only.)\n\n UI Scheme Icons Folder Not Saved." --LOC_NOTES: localize this
							messagebox str title:"Error" --LOC_NOTES: localize this
						)
					)
					DestroyDialog SaveDialog
					
				)--end on go pressed
				
				on BtnCancel pressed do	DestroyDialog SaveDialog 

				on AllOptions pressed do
				(
						chkCUI.checked = true
						chkKBD.checked = true
						chkMNU.checked = true
						chkQOP.checked = true
						chkCLR.checked = true
				)--end on AllOptions pressed
				
				on BtnNone pressed do
				(
						chkCUI.checked = false
						chkKBD.checked = false
						chkMNU.checked = false
						chkQOP.checked = false
						chkCLR.checked = false
				)--end on BtnNone pressed
			)--end rollout
		)--If UIScheme_Filename != undefined
		
		CreateDialog SaveDialog 	
)--end on execute
)--end macro save scheme