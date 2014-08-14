fn flt_objects = (srcObj != undefined) -- objects filter 


srcObj =pickObject()
i=1

	menuStr= stringStream ""

	format "rcmenu MyRCmenu(\n" to:menuStr

	for m in srcObj.modifiers do
	(
		mStr=classof m as string
		format "	menuItem menu% \"%\"\n" mStr mStr to:menuStr
	)

	format "	separator sep%\n" (i+=1) to:menuStr
	mStr= srcObj.baseObject as string
	format "	menuItem menu% \"%\"\n" mStr mStr to:menuStr

	format "	separator sep%\n" (i+=1) to:menuStr
	format "	menuItem menuAll \"All\"" to:menuStr

	format "\n)" to:menuStr

execute(menuStr)
registerRightClickMenu MyRCmenu
popUpMenu MyRCmenu





format "<fmt_string>" {values} to:<stringstream> 


rcmenu MyRCmenu 
( 

	menuItem mi_cs "Cast Shadows" checked:false 
	menuItem mi_rs "Receive Shadows" checked:false 


	
	on MyRCmenu open do 
	( 
		local sel = (selection.count == 1) 
		-- Enable if only one object is selected 
		mi_cs.enabled = mi_rs.enabled = sel 
		-- Set check state of items 
		if sel do 
		( 
			mi_cs.checked = $.castShadows 
			mi_rs.checked = $.receiveShadows 
		) 
	) 
	-- set up event handlers for items 
	on mi_cs picked do $.castShadows = (not $.castShadows) 
	on mi_rs picked do $.receiveShadows = (not $.receiveShadows) 
) 
-- register the rcmenu 
registerRightClickMenu MyRCmenu


popUpMenu MyRCmenu 
