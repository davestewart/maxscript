macroScript openMaxFile
	icon:#("set_and_get_paths",2)
	category:"Tools"
	toolTip:"Set Scene path to current directory"
	(
	setdir #scene sysinfo.currentdir
	)
