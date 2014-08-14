	on axObj BeforeLabelEdit Cancel do format "%, %\n" "BeforeLabelEdit" Cancel 
	on axObj AfterLabelEdit Cancel NewString do format "%, %, %\n" "AfterLabelEdit" Cancel NewString 
	on axObj ColumnClick ColumnHeader do format "%, %\n" "ColumnClick" ColumnHeader 
	on axObj ItemClick Item do format "%, %\n" "ItemClick" Item 
	on axObj KeyDown KeyCode Shift do format "%, %, %\n" "KeyDown" KeyCode Shift 
	on axObj KeyUp KeyCode Shift do format "%, %, %\n" "KeyUp" KeyCode Shift
	on axObj KeyPress KeyAscii do format "%, %\n" "KeyPress" KeyAscii 
	on axObj MouseDown Button Shift x y do format "%, %, %, %, %\n" "MouseDown" Button Shift x y 
	on axObj MouseMove Button Shift x y do format "%, %, %, %, %\n" "MouseMove" Button Shift x y 
	on axObj MouseUp Button Shift x y do format "%, %, %, %, %\n" "MouseUp" Button Shift x y 
	on axObj Click do format "%\n" "Click"
	on axObj DblClick do format "%\n" "Doubleclick"
	on axObj OLEStartDrag &Data &AllowedEffects do format "%, %, %\n" "OLEStartDrag" &Data &AllowedEffects 
	on axObj OLEGiveFeedback &Effect &DefaultCursors do format "%, %, %\n" "OLEGiveFeedback" &Effect &DefaultCursors 
	on axObj OLESetData &Data &DataFormat do format "%, %, %\n" "OLESetData" &Data &DataFormat 
	on axObj OLECompleteDrag &Effect do format "%, %\n" "OLECompleteDrag" &Effect 
	on axObj OLEDragOver &Data &Effect &Button &Shift &x &y &State do format "%, %, %, %, %, %, %\n" "OLEDragOver" &Data &Effect &Button &Shift &x &y &State 
	on axObj OLEDragDrop &Data &Effect &Button &Shift &x &y do format "%, %, %, %, %, %, %\n" "OLEDragDrop" &Data &Effect &Button &Shift &x &y 
	on axObj ItemCheck Item do format "%, %\n" "ItemCheck" Item 
