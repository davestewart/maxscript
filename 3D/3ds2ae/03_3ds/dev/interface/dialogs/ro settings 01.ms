try(destroyDialog roSettings);catch()

rollout roSettings "Settings" width:316 height:340
	(

	GroupBox grpAfter "After Effects" pos:[8,8] width:304 height:128
		label lblAfter "After Effects executable file (afterfx.exe)" pos:[16,24] width:288 height:16
		button btnOpen ">" pos:[16,40] width:16 height:16
		edittext edtFile "" pos:[32,40] width:272 height:16
		dropdownList ddSelectComp "Select Comp" pos:[16,64] width:288 height:40 items:#("Comp 1", "Comp 2", "-----------------------------------------", "Get comps from After Effects...")
		label lblWidth "width: 800, height:600, duration:1000 frames, color depth:24 bit" pos:[16,112] width:288 height:16

	GroupBox grp3dsmax "3dsmax" pos:[8,144] width:304 height:192
		GroupBox grpCamera "Camera to Comp relationship" pos:[16,160] width:288 height:72
			dropdownList ddCamera "Camera" pos:[24,176] width:136 height:40 items:#("Active Camera", "--------------------------------------------", "Camera 1", "Camera 2", "Camera 3")
			dropdownList ddComp "Comp" pos:[160,176] width:136 height:40 items:#("Comp 1", "Comp 2", "-----------------------------------------", "New Comp", "Get comps from After Effects...")


		GroupBox grpOrigin "3dsmax world origin" pos:[16,240] width:136 height:88
			checkbox chkUseOrigin "Use" pos:[24,256] width:48 height:16
			dropDownList ddlOriginType "" pos:[80,256] width:64 height:21 items:#("Light", "Null")
			spinner spnScaleOrigin "Scale by (%): " pos:[78,280] width:64 height:16 range:[0,100,0] type:#integer scale:1

		GroupBox grpData "Data Storage" pos:[160,240] width:144 height:88
			radioButtons rdoDataStore "" pos:[168,256] width:105 height:64 labels:#("ini file", "user properties", "track view", "Custom Attributes") columns:1


	on btnOpen pressed do
		(
		local str=getopenfilename caption:"Select After Effects application file (AfterFX.exe)..." types:"Application (*.exe)|AfterFX.exe"
		if str!=undefined then edtFile.text=str
		)
	)


createDialog roSettings

