rollout unnamedRollout "Untitled" width:816 height:192
(
	GroupBox grpName "Setting Name" pos:[4,4] width:128 height:184
		edittext edtName "" pos:[8,48] width:120 height:16

	GroupBox grpTime "Time Output" pos:[136,4] width:120 height:184
		label lblFrom "From" pos:[160,32] width:32 height:16
		label lblTo "To" pos:[208,32] width:32 height:16

		button btnRndType "S" pos:[140,48] width:16 height:16 toolTip:"S=single, C=current, R=range"
		spinner spnRndFrom "" pos:[156,48] width:48 height:16 range:[0,9999,0] type:#integer scale:1
		spinner spnRndTo "" pos:[204,48] width:48 height:16 range:[0,9999,0] type:#integer scale:1

		
	GroupBox grpSize "Output Size" pos:[260,4] width:104 height:184
		label lblWidth "Width" pos:[269,32] width:32 height:16
		label lblHeight "Height" pos:[316,32] width:32 height:16
		
		spinner spnWidth "" pos:[264,48] width:48 height:16 range:[0,9999,0] type:#integer scale:1
		spinner spnHeight "" pos:[312,48] width:48 height:16 range:[0,9999,0] type:#integer scale:1

	GroupBox grpScanline "Scanline Options" pos:[368,4] width:100 height:184
		label lblAA "aa" pos:[372,32] width:16 height:16
		label lblSH "sh" pos:[388,32] width:16 height:16
		label lblMP "mp" pos:[403,32] width:16 height:16
		label lblFM "fm" pos:[421,32] width:16 height:16
		label lblREF "ref" pos:[436,32] width:16 height:16
		label lblMB "mb" pos:[450,32] width:16 height:16

		checkbox chkAA "" pos:[372,48] width:16 height:16 enabled:true checked:false
		checkbox chkSH "" pos:[388,48] width:16 height:16 enabled:true checked:false
		checkbox chkMP "" pos:[404,48] width:16 height:16 enabled:true checked:false
		checkbox chkFM "" pos:[420,48] width:16 height:16 enabled:true checked:false
		checkbox chkREF "" pos:[436,48] width:16 height:16 enabled:true checked:false
		checkbox chkMB "" pos:[450,48] width:16 height:16 enabled:true checked:false

	
	GroupBox grpOutput "Render Output" pos:[472,4] width:340 height:184
		label lblPath "Output path" pos:[496,32] width:160 height:16

		button btnPath ">" pos:[478,48] width:16 height:16 toolTip:"S=single, C=current, R=range"
		edittext edtPath "" pos:[492,48] width:300 height:16
		checkbox chkSave "" pos:[794,48] width:16 height:16 enabled:true checked:false
)