try(destroyDialog roSettings);catch()

rollout roSettings "Settings" width:536 height:584
(
	GroupBox grpAfter "After Effects" pos:[8,8] width:504 height:56
	label lblAfter "After Effects executable file (afterfx.exe)" pos:[16,24] width:288 height:16
	button btnOpen ">" pos:[16,40] width:16 height:16
	edittext edtFile "" pos:[32,40] width:472 height:16
	GroupBox grp3dsmax "3dsmax" pos:[8,72] width:304 height:192
	GroupBox grpCamera "Camera to Comp relationship" pos:[16,88] width:288 height:72
	dropdownList ddCamera "Camera" pos:[24,104] width:136 height:40 items:#("Active Camera", "--------------------------------------------", "Camera 1", "Camera 2", "Camera 3")
	dropdownList ddComp "Comp" pos:[160,104] width:136 height:40 items:#("Comp 1", "Comp 2", "-----------------------------------------", "New Comp", "Get comps from After Effects...")
	GroupBox grpOrigin "3dsmax world origin" pos:[16,168] width:136 height:88
	checkbox chkUseOrigin "Use" pos:[24,184] width:48 height:16
	dropdownList ddlOriginType "" pos:[80,184] width:64 height:21 items:#("Light", "Null")
	spinner spnScaleOrigin "Scale by (%): " pos:[78,208] width:64 height:16 range:[0,100,0] type:#integer scale:1
	GroupBox grpData "Data Storage" pos:[160,168] width:144 height:88
	radiobuttons rdoDataStore "" pos:[168,184] width:105 height:64 labels:#("ini file", "user properties", "track view", "Custom Attributes") columns:1

	GroupBox grpAnimation "Animation" pos:[176,424] width:160 height:72
	radiobuttons rdoKeyframes "Keyframes:" pos:[184,440] width:123 height:46 labels:#("Bezier keyframes", "A key on every frame") columns:1
	GroupBox grpHierarchy "Hierarchy" pos:[8,424] width:160 height:144
	radiobuttons rdoOptions "Options" pos:[16,440] width:111 height:62 labels:#("Always use", "Use only if needed", "Never use") columns:1
	radiobuttons rdoExport "Export as" pos:[16,512] width:149 height:46 labels:#("Local space (parented)", "World space (un-parented)") columns:1

	GroupBox grpRendering "File naming" pos:[8,272] width:256 height:88
	dropdownList ddlFileNaming "" pos:[16,296] width:240 height:21 items:#("scene | camera | version | frame", "camera | frame")
	GroupBox grpHousekeeping "Housekeeping" pos:[272,272] width:256 height:88
	checkbox chkNameLayers "Name: AE layers from G-Buffer name" pos:[280,288] width:200 height:16 checked:true
	checkbox chkNameEffects "Name: AE effects from G-Buffer name / ID" pos:[280,304] width:200 height:16 checked:true
	checkbox chkCommentProj "Comment: AE project items with max file + cam." pos:[280,320] width:240 height:16 checked:true
	checkbox chkCommentFiles "Comment: files on disk with max file + camera" pos:[280,336] width:246 height:16 checked:true
	checkbox chk6 "Generate Report" pos:[320,80] width:131 height:16

	on btnOpen pressed do
	(
	local str=getopenfilename caption:"Select After Effects application file (AfterFX.exe)..." types:"Application (*.exe)|AfterFX.exe"
	if str!=undefined then edtFile.text=str
	)
)

createdialog roSettings

