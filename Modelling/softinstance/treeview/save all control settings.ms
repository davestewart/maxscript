rollout ro1 "ui items" 
	( 

	fn getSetControlValue c =
		(
		local cStr = c as string
		local cClass = (filterstring cStr ":")[1]
		local cName= (filterstring cStr ":")[2]

		case cClass of
			(
			"CheckBoxControl":
				(
				format "% | %\n" cName c.checked
				)
			"CheckButtonControl":
				(
				format "% | %\n" cName c.state
				)
			"ColorPickerControl":
				(
				format "% | %\n" cName c.color
				)
			"ComboBoxControl":
				(
				format "% | %\n" cName c.items
				)
			"EditTextControl":
				(
				format "% | %\n" cName c.text
				)
			"ListBoxControl":
				(
				format "% | %\n" cName c.items
				)
			"MapButtonControl":
				(
				format "% | %\n" cName c.map
				)
			"RadioControl":
				(
				format "% | %\n" cName c.state
				)
			"SpinnerControl":
				(
				format "% | %\n" cName c.value
				)
			"SliderControl":
				(
				format "% | %\n" cName c.value
				)
			
			default:
				(
				)
			)
		)


	bitmap a1 bitmap:(bitmap 50 50) 
	button a2 "button" 
	checkbox a3 "checkbox" 
	checkbutton a4 "checkbutton" 
	colorpicker a5 "colorpicker: " 
	combobox a6 "combobox:" items:#("1/2", "1/4", "1/8") height:5 
	dropdownlist a7 "dropdownlist:" items:#("1/2", "1/4", "1/8") 
	edittext a8 "edittext: " 
	label a9 "label" 
	listbox a10 "listbox: " items:#("1/2", "1/4", "1/8" ) height:3 
	mapbutton a11 "mapButton" 
	materialbutton a12 "materialbutton" 
	pickbutton a13 "pickbutton" 
	progressbar a14 
	radiobuttons a15 "radiobuttons: " labels:#("lbl 1", "lbl 2", "lbl 3") 
	spinner a16 "spinner: " 
	slider a17 "slider: " 
	timer a18 


	on ro1 open do for c in ro1.controls do getSetControlValue c
	on ro1 oktoclose do for c in ro1.controls do getSetControlValue c

	)

createdialog ro1

/*
BitmapControl:a1
ButtonControl:a2
CheckBoxControl:a3
CheckButtonControl:a4
ColorPickerControl:a5
ComboBoxControl:a6
ComboBoxControl:a7
EditTextControl:a8
LabelControl:a9
ListBoxControl:a10
MapButtonControl:a11
MtlButtonControl:a12
PickerControl:a13
ProgressBar:a14
RadioControl:a15
SpinnerControl:a16
SliderControl:a17
Timer:a18
*/