macroScript setScriptPath
	icon:#("~set_and_get_paths",1)
	category:"Tools"
	toolTip:"Set Script path to current directory"
	(
	local dir=sysinfo.currentdir
	setdir #scripts dir
	format "Script path set to %\n" dir
	)
