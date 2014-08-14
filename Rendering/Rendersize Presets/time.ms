fn secondsToMinutes t =
	(
	local s	= (mod t 60) as integer
	local m	= ((t - s) / 60) as integer

	if s < 10 do s = "0" + s as string
	return m as string + ":" + s as string
	)
	
	
secondsToMinutes 250
	
microsecondsToMinutesAndSeconds 2000


	t = (ms / 1000.0)
	local s	= (mod t 60) as integer
	local m	= ((t - s) / 60) as integer

	if s < 10 do s = "0" + s as string
	return m as string + ":" + s as string
