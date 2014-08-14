(

fn getControllerRange ctrl =
	(
	local arrTime	= #()
	fn getControllerTimes ctrl =
		(
		for i = 1 to ctrl.numSubs do
			(
			local range = getTimeRange ctrl[i].controller
			if range.start - range.end != 0f then
				(
				append arrTime range.start
				append arrTime range.end
				)
			getControllerTimesRec ctrl[i]
			)
		)
	getControllerTimes ctrl
	return interval (aMin arrTime) (aMax arrTime) 
	)



fn createFolder path =
	(
	local arrPath = filterString path "/"
	local path = ""
	local state = true
	
	for i = 1 to arrPath.count do
		(
		path += arrPath[i] + "/"
		
		if doesFileExist path then state = true
		else state = makeDir path

		if state == false then return false
		)
	return true
	)


local cam		= viewport.getCamera()
local fName 	= cam.name
local bPath 	= "E:/02_Current_Jobs/2006-09 - Jetix promo/3 - renders/"
local fPath		= bPath + fName + "/"

createFolder fPath

cRange = getControllerRange cam.transform.controller
getControllerTimes cam.transform.controller

rendOutputFilename = fPath + " "
rendTimeType	= 3
rendStart		= cRange.start
rendEnd			= cRange.end

)

renderSceneDialog.update()
renderSceneDialog.open()