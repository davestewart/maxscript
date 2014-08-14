expr = ""

	function getSubAnims src trg tmpPath =
	(
		local expr = ""
		local subAnims = getSubAnimNames src
		if subAnims != undefined do
		(
			for sa in subAnims do
			(
				local ctrl = src[sa].controller
				local srcPath = tmpPath + "[#" + sa + "]"
					print srcPath
				if ctrl != undefined AND ctrl == trg then
				(
					-- success!
					srcPath += ".controller"
				)
				else(
					-- failure
					srcPath = getSubAnims src[sa] trg srcPath
				)
			)
		)
		print srcPath
		return srcPath
	)
		

	trg        = $.pos.controller[2].controller -- second controller in a position list


str = getSubAnims $ trg ("$" + $.name)


str
