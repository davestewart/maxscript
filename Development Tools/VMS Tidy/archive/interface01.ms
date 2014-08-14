	GroupBox grpColStatus "Status" pos:[8,8] width:184 height:40
		checkbutton chkColStatus "Enabled" pos:[16,24] width:166 height:16 toolTip:"Click to enable / disable on create" checked:true highlightColor:(color 197 220 197)

	GroupBox grpCol "Base" pos:[8,56] width:184 height:48
		colorPicker cpClr "" pos:[16,72] width:168 height:24 color:(color 237 178 50) title:"Choose a color"

	GroupBox grpColVar " +/- " pos:[8,112] width:184 height:168
		spinner spnClrRedVar "Red " pos:[39,137] width:56 height:16 range:[0,255,200] type:#integer
		colorPicker cpClrRedMin "" pos:[103,137] width:24 height:16 enabled:false color:(color 64 128 255)
		colorPicker cpClrRedBas "" pos:[132,137] width:24 height:16 enabled:false color:(color 64 128 255)
		colorPicker cpClrRedMax "" pos:[161,137] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrRedMin "000" pos:[108,156] width:20 height:16
		label lblClrRedMax "000" pos:[166,156] width:20 height:16

		spinner spnClrGrnVar "Green " pos:[30,185] width:65 height:16 range:[0,255,100] type:#integer--
		colorPicker cpClrGrnMin "" pos:[103,185] width:24 height:16 enabled:false color:(color 64 128 255)
		colorPicker cpClrGrnBas "" pos:[132,185] width:24 height:16 enabled:false color:(color 64 128 255)
		colorPicker cpClrGrnMax "" pos:[161,185] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrGrnMin "000" pos:[108,204] width:20 height:16
		label lblClrGrnMax "000" pos:[166,204] width:20 height:16

		spinner spnClrBluVar "Blue " pos:[36,232] width:59 height:16 range:[0,255,50] type:#integer--
		colorPicker cpClrBluMin "" pos:[103,233] width:24 height:16 enabled:false color:(color 64 128 255)
		colorPicker cpClrBluBas "" pos:[132,233] width:24 height:16 enabled:false color:(color 64 128 255)
		colorPicker cpClrBluMax "" pos:[161,233] width:24 height:16 enabled:false color:(color 64 128 255)
		label lblClrBluMin "000" pos:[108,252] width:20 height:16
		label lblClrBluMax "000" pos:[166,252] width:20 height:16

	GroupBox grpColGen "Colour Generation" pos:[8,288] width:184 height:50
		radiobuttons rdoColGen "" pos:[16,308] width:149 height:16 labels:#("Random", "Smooth") columns:2

	GroupBox grpPrv "Preview" pos:[8,344] width:184 height:48
		colorPicker cpPrv1 "" pos:[16,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv2 "" pos:[32,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv3 "" pos:[48,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv4 "" pos:[64,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv5 "" pos:[80,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv6 "" pos:[96,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv7 "" pos:[112,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv8 "" pos:[128,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv9 "" pos:[144,364] width:20 height:16 enabled:false color:(color 255 255 255)
		colorPicker cpPrv10 "" pos:[160,364] width:20 height:16 enabled:false color:(color 255 255 255)
