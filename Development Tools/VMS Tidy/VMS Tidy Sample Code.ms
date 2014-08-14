	local sampleArr=#("",

	"
	GroupBox grpButton \"Objects\" pos:[8,8] width:72 height:104
	pickbutton btn1 \"Object\" pos:[16,24] width:56 height:16
	GroupBox grpSpn \"Values\" pos:[88,8] width:104 height:104
	spinner spn5 \"Hair\" pos:[131,24] width:51 height:16
	GroupBox grpColor \"Color\" pos:[200,8] width:160 height:104
	radiobuttons rdo1 \"\" pos:[208,24] width:155 height:16 labels:#(\"1\", \"2\", \"3\", \"4\", \"5\") default:3 columns:5
	checkbutton ckb1 \"Mat. Only\" pos:[16,40] width:56 height:16
	spinner spn4 \"Legs\" pos:[127,40] width:55 height:16 range:[0,100,0]
	colorPicker cp1 \"\" pos:[208,40] width:144 height:64
	checkbox chk3 \"Yes\" pos:[16,56] width:56 height:16
	spinner spn1 \"Arms\" pos:[127,56] width:55 height:16 range:[0,100,0]
	checkbox chk1 \"No\" pos:[16,72] width:56 height:16
	spinner spn2 \"Face\" pos:[126,72] width:56 height:16 range:[0,100,0]
	checkbox chk2 \"Maybe\" pos:[16,88] width:56 height:16
	spinner spn3 \"Tail\" pos:[133,88] width:49 height:16 range:[0,100,0]
	GroupBox grpBody \"Body Parts\" pos:[8,120] width:184 height:144
	slider sld1 \"\" pos:[80,136] width:104 height:25
	GroupBox grpList \"GroupBox Lists\" pos:[200,120] width:160 height:144
	listbox lbx1 \"\" pos:[208,136] width:72 height:6 items:#(\"Hello\", \"My\", \"Name\", \"Is\", \"Barney\")
	listbox lbx2 \"\" pos:[280,136] width:72 height:6 items:#(\"What's\", \"The\", \"Story\", \"Morning\", \"Glory\")
	label lbl1 \"Fingers\" pos:[16,141] width:56 height:16
	slider sld4 \"\" pos:[80,160] width:104 height:25 range:[0,100,25]
	label lbl2 \"Thumbs\" pos:[16,165] width:56 height:16
	slider sld5 \"\" pos:[80,184] width:104 height:25 range:[0,100,50]
	label lbl3 \"Hands\" pos:[16,189] width:56 height:16
	slider sld6 \"\" pos:[80,208] width:104 height:25 range:[0,100,75]
	label lbl4 \"Legs\" pos:[16,213] width:56 height:16
	button btn3 \"Done\" pos:[208,224] width:144 height:24
	slider sld7 \"\" pos:[80,232] width:104 height:25 range:[0,100,100]
	label lbl5 \"Sparrows\" pos:[16,237] width:56 height:16
	progressBar pb1 \"Percent Done\" pos:[208,248] width:144 height:8 value:50",

	"GroupBox grpColStatus \"Status\" pos:[8,8] width:184 height:40
	checkbutton chkColStatus \"Enabled\" pos:[16,24] width:166 height:16 toolTip:\"Click to enable / disable on create\" checked:true highlightColor:(color 197 220 197)
	GroupBox grpCol \"Base\" pos:[8,56] width:184 height:48
	colorPicker cpClrBluBas \"\" pos:[132,233] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpClr \"\" pos:[16,72] width:168 height:24 color:(color 237 178 50) title:\"Choose a color\"
	GroupBox grpColVar \" +/- \" pos:[8,112] width:184 height:168
	spinner spnClrRedVar \"Red \" pos:[39,137] width:56 height:16 range:[0,255,200] type:#integer
	colorPicker cpClrRedMin \"\" pos:[103,137] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrRedMin \"000\" pos:[108,156] width:20 height:16
	colorPicker cpClrRedBas \"\" pos:[132,137] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpPrv3 \"\" pos:[48,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpClrGrnBas \"\" pos:[132,185] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpClrGrnMax \"\" pos:[161,185] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrGrnMax \"000\" pos:[166,204] width:20 height:16
	spinner spnClrBluVar \"Blue \" pos:[36,232] width:59 height:16 range:[0,255,50] type:#integer--
	colorPicker cpPrv5 \"\" pos:[80,364] width:20 height:16 enabled:false color:(color 255 255 255)
	label lblClrRedMax \"000\" pos:[166,156] width:20 height:16
	colorPicker cpPrv4 \"\" pos:[64,364] width:20 height:16 enabled:false color:(color 255 255 255)
	label lblClrGrnMin \"000\" pos:[108,204] width:20 height:16
	spinner spnClrGrnVar \"Green \" pos:[30,185] width:65 height:16 range:[0,255,100] type:#integer--
	colorPicker cpPrv7 \"\" pos:[112,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv8 \"\" pos:[128,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpClrGrnMin \"\" pos:[103,185] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMax \"000\" pos:[166,252] width:20 height:16
	colorPicker cpClrRedMax \"\" pos:[161,137] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpPrv2 \"\" pos:[32,364] width:20 height:16 enabled:false color:(color 255 255 255)
	GroupBox grpColGen \"Colour Generation\" pos:[8,288] width:184 height:50
	radiobuttons rdoColGen \"\" pos:[16,308] width:149 height:16 labels:#(\"Random\", \"Smooth\") columns:2
	GroupBox grpPrv \"Preview\" pos:[8,344] width:184 height:48
	colorPicker cpPrv1 \"\" pos:[16,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv6 \"\" pos:[96,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv9 \"\" pos:[144,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpClrBluMin \"\" pos:[103,233] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMin \"000\" pos:[108,252] width:20 height:16
	colorPicker cpClrBluMax \"\" pos:[161,233] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpPrv10 \"\" pos:[160,364] width:20 height:16 enabled:false color:(color 255 255 255)",
	
	"
	GroupBox grpSettings \"Settings management\" pos:[4,4] width:232 height:42
	button btnCopy \"Copy...\" pos:[8,24] width:56 height:16
	button btnPaste \"Paste...\" pos:[64,24] width:64 height:16 enabled:false
	dropDownList ddlCopyType \"\" pos:[130,22] width:104 height:21 items:#(\"All settings\", \"Output size\", \"Time\", \"Scanline options\", \"Render output\", \"Renderer\", \"Camera\") enabled:false
	GroupBox grpPreset \"Preset management\" pos:[240,4] width:128 height:42
	button btnDown \"Move Down\" pos:[244,24] width:68 height:16
	button btnUp \"Move Up\" pos:[312,24] width:52 height:16
	GroupBox grpFile \"Preset I/O\" pos:[372,4] width:188 height:42
	button btnSave \"Save\" pos:[376,24] width:60 height:16
	button btnLoad \"Load\" pos:[436,24] width:60 height:16
	button btnClear \"Clear\" pos:[496,24] width:60 height:16
	GroupBox grpGlobal \"Global options\" pos:[564,4] width:262 height:42
	checkbox chkAnim \"Auto-open animations\" pos:[572,24] width:124 height:16 checked:true
	checkbox chkSaveOnClose \"Auto-save on close\" pos:[700,24] width:120 height:16 checked:false
	GroupBox grpRenderWanger \"RenderWanger v0.8\" pos:[830,4] width:146 height:42
	button btnHelp \"Help\" pos:[836,24] width:60 height:16
	button btnWeb \"Report bugs\" pos:[896,24] width:76 height:16"

)

