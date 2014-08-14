rollout roTest "Untitled" width:368 height:272
(

	GroupBox grp4 "GroupBox" pos:[8,8] width:72 height:104
		pickbutton btn1 "PickButton" pos:[16,24] width:56 height:16

	GroupBox grp1 "GroupBox" pos:[88,8] width:104 height:104
		spinner spn1 "Spn1" pos:[104,24] width:70 height:16

	GroupBox grp2 "GroupBox" pos:[200,8] width:160 height:104
		radiobuttons rdo1 "" pos:[208,24] width:155 height:16 labels:#("1", "2", "3", "4", "5") default:3 columns:5

	checkbutton ckb1 "CheckButton" pos:[16,40] width:56 height:16
	spinner spn2 "Spn1" pos:[104,40] width:70 height:16 range:[0,100,0]
		colorPicker cp1 "" pos:[208,40] width:144 height:64

	checkbox chk3 "Yes" pos:[16,56] width:56 height:16
	spinner spn3 "Spn1" pos:[104,56] width:70 height:16 range:[0,100,0]
	checkbox chk1 "No" pos:[16,72] width:56 height:16
	spinner spn4 "Spn1" pos:[104,72] width:70 height:16 range:[0,100,0]
	checkbox chk2 "Maybe" pos:[16,88] width:56 height:16
	spinner spn5 "Spn1" pos:[104,88] width:70 height:16 range:[0,100,0]

	GroupBox grp3 "GroupBox" pos:[8,120] width:184 height:144
		slider sld1 "" pos:[80,136] width:104 height:25

	GroupBox grp5 "GroupBox" pos:[200,120] width:160 height:144
		listbox lbx1 "" pos:[208,136] width:72 height:6 items:#("Hello", "My", "Name", "Is", "Barney")
		listbox lbx2 "" pos:[280,136] width:72 height:6 items:#("What's", "The", "Story", "Morning", "Glory")

	label lbl1 "Fingers" pos:[16,141] width:56 height:16
	slider sld4 "" pos:[80,160] width:104 height:25 range:[0,100,25]
	label lbl2 "Thumbs" pos:[16,165] width:56 height:16
	slider sld5 "" pos:[80,184] width:104 height:25 range:[0,100,50]
	label lbl3 "Hands" pos:[16,189] width:56 height:16
	slider sld6 "" pos:[80,208] width:104 height:25 range:[0,100,75]
	label lbl4 "Legs" pos:[16,213] width:56 height:16
		button btn3 "Button" pos:[208,224] width:144 height:24

	slider sld7 "" pos:[80,232] width:104 height:25 range:[0,100,100]
	label lbl5 "Sparrows" pos:[16,237] width:56 height:16
		progressBar pb1 "ProgressBar" pos:[208,248] width:144 height:8 value:50)
createDialog roTest 