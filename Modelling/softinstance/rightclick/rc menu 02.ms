fn flt_objects = (srcObj != undefined) -- objects filter 


srcObj =pickObject()


	menuStr=""
	for m in srcObj.modifiers do
	(
		mStr=classof m as string
		menuStr+= "menuItem menu"+mStr+" \""+mStr+"\"\n"
	)
	mStr= srcObj.baseObject as string
	--menuStr+= "separator sep1 filter:flt_objects\n"
	menuStr+= "separator sep1\n"
	menuStr+= "menuItem menu"+mStr+" \""+mStr+"\"\n"
	menuStr+= "separator sep2\n"



	menuStr+= "menuItem menuAll \"All\"\n"

str="rcmenu MyRCmenu(\n"
str+=menuStr
str+="\n)"
execute(str)
registerRightClickMenu MyRCmenu
popUpMenu MyRCmenu

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
