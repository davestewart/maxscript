rollout RSro3 "Tools" width:984 height:56
(
	GroupBox grpSettings "Settings management" pos:[4,4] width:232 height:44
	button btnCopy "Copy" pos:[8,24] width:56 height:16
	dropDownList ddlCopyType "" pos:[64,22] width:104 height:21 items:#("All settings", "Output size", "Time", "Scanline options", "Render output", "Renderer", "Camera")
	button btnPaste "Paste" pos:[168,24] width:64 height:16

	GroupBox grpPreset "Preset management" pos:[240,4] width:128 height:44
	button btnDown "Move Down" pos:[244,24] width:68 height:16
	button btnUp "Move Up" pos:[312,24] width:52 height:16

	GroupBox grpFile "Preset I/O" pos:[372,4] width:128 height:44
	button btnSave "Save" pos:[376,24] width:60 height:16
	button btnLoad "Load" pos:[436,24] width:60 height:16

	GroupBox grpGlobal "Global options" pos:[504,4] width:322 height:44
	checkbox chkAnim "Auto-open animations" pos:[512,24] width:124 height:16 checked:true
	checkbox chkSave "Save on close" pos:[640,24] width:96 height:16 checked:true

	GroupBox grpRenderWanger "RenderWanger v0.8" pos:[830,4] width:146 height:44
	button btnHelp "Help" pos:[836,24] width:60 height:16
	button btnWeb "Report bugs" pos:[896,24] width:76 height:16


)



if RSFloater != undefined then closerolloutfloater RSFloater
	RSFloater = newRolloutFloater "RenderWanger! v0.8 | Easily manage multiple rendering configurations. Load and save by project, activity or user." 1010 100 --1010 300
	RSFloater.pos = [0,76]

addRollout RSro3 RSFloater
