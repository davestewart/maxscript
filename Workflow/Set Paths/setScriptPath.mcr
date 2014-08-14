macroScript setScriptPath
	icon:#("set_and_get_paths",1)
	category:"Tools"
	toolTip:"Set Script path to current directory"
	(
	setdir #scripts sysinfo.currentdir
	)
