--UI Tidy test rollout

try(destroyDialog vmsTidyTestRo);catch()

rollout vmsTidyTestRo "vmsTidy Test Rollout" width:843 height:562
(
	angle ang1 "Angle Control" pos:[8,8] width:80 height:80
	ActiveXControl actx1 "http://www.yahoo.com" pos:[96,8] width:80 height:80
	bitmap bmp1 "Bitmap" pos:[184,8] width:80 height:80 fileName:"C:/Temp/Drive.bmp"
	button btn25 "Button" pos:[272,8] width:80 height:80
	checkbox chk17 "Checkbox" pos:[360,8] width:80 height:16
	checkbutton ckb3 "CheckButton" pos:[448,8] width:80 height:80
	colorPicker cp3 "ColorPicker" pos:[536,8] width:80 height:80
	combobox cbx1 "ComboBox" pos:[8,96] width:72 height:4 items:#("1", "2", "3")
	CurveControl curv1 "Curve Control" pos:[96,96] width:168 height:144
	dropdownList ddl5 "DropDownList" pos:[272,96] width:80 height:40 items:#("1", "2", "3")
	edittext edt6 "" pos:[360,96] width:80 height:80 text:"Edit Text control"
	GroupBox grp32 "GroupBox" pos:[448,96] width:80 height:80
	HyperLink hyp1 "Hyperlink" pos:[536,104] width:80 height:72
	ImgTag img "Img Tag" pos:[8,272] width:80 height:80
	label lbl11 "Label" pos:[96,272] width:80 height:80
	listbox lbx5 "ListBox" pos:[184,272] width:80 height:4 items:#("1", "2", "3")
	mapButton btn27 "MapButton" pos:[272,272] width:80 height:80
	materialButton btn28 "MaterialButton" pos:[360,272] width:80 height:80
	multiListBox mList "Multi List Box" pos:[448,272] width:80 height:4 items:#("1", "2", "3") selection:#(1, 3)
	pickbutton btn29 "PickButton" pos:[536,272] width:80 height:80
	--popUpMenu pop "PopUp Menu" pos:[8,208] width:45 height:36
	progressBar pb2 "ProgressBar" pos:[96,360] width:80 height:80 value:50
	radiobuttons rdo6 "RadioButtons" pos:[184,360] width:62 height:30 labels:#("1", "2") columns:2
	slider sld11 "Slider" pos:[272,360] width:80 height:44
	spinner spn11 "" pos:[360,360] width:80 height:16
	subRollout subRo "Sub Rollout" pos:[448,360] width:80 height:80
	Timer tmr1 "Timer" pos:[536,360] width:24 height:24
)
createdialog vmsTidyTestRo

