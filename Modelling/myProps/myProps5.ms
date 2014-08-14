utility myPropsUtility "myProps" width:160 height:384
(
local printState = false
global myObj
global myMods= #()
global myAttribs= #()
global myTargetAttrib
global myTargetAttribCurVal
global myModSelected = true


----------------------------------------
-- interface
----------------------------------------

	GroupBox grpObject "Object" pos:[8,8] width:144 height:40
	pickbutton btnPick "Pick Object" pos:[16,24] width:64 height:16
	button btnClear "Clear Object" pos:[80,24] width:64 height:16

	GroupBox grpAttribs "Element" pos:[8,56] width:144 height:272
	dropdownList ddlMods "Stack element" pos:[16,72] width:128 height:40 enabled:false
	dropdownList ddlAttribs "Attributes" pos:[16,120] width:128 height:40 enabled:false

	label lblAttrib "Attrib:" pos:[16,168] width:128 height:16
	label lblAttribVal "Value:" pos:[16,184] width:128 height:16
	label lblAttribClass "Class:" pos:[16,200] width:128 height:16
	label lblAttribs "New value:" pos:[16,272] width:56 height:16
	edittext edtNewAttribVal "" pos:[72,272] width:72 height:16

	button btnAttribDoIt "Do it" pos:[16,296] width:128 height:16

)
