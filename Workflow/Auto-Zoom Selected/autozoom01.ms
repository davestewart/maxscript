fn autoZoom =
	(
	if (subObjectLevel == 0 || subObjectLevel == undefined) then max zoomext sel
	)



callbacks.removeScripts id:#autoZoom
callbacks.addScript #selectionSetChanged "autoZoom()" persistent:true id:#autoZoom

subObjectLevel
