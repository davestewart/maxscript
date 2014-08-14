rcmenu MyRCmenu 
( 
	fn flt_objects = ($ != undefined) -- objects filter 
	fn flt_shapes = (isKindOf $ Shape) -- shapes filter 
	menuItem mi_cs "Cast Shadows" checked:false 
	menuItem mi_rs "Receive Shadows" checked:false 
	separator sep2 filter:flt_objects 
	subMenu "Modifiers" filter:flt_objects -- begin subMenu 
	( 
		-- Add common objects 
		menuItem mi_bend "Bend" 
		menuItem mi_twist "Twist" 
		-- Add shape only modifiers 
		separator sep3 filter:flt_shapes 
	) 
	on mi_bend picked do messagebox "!!" 
) 
registerRightClickMenu MyRcmenu -- register the rcmenu 




popUpMenu MyRCmenu 