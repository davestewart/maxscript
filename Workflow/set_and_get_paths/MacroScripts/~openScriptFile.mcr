macroScript openScriptFile
	icon:#("~set_and_get_paths",3)
	category:"Tools"
	toolTip:"Open Script File..."
	(
	f=getOpenFileName caption:"Choose Editor File" types:"Script files (*.ms, *.mcr)|*.ms;*.mcr|All files (*.*)|*.*"
	if f!=undefined then edit f
	)
