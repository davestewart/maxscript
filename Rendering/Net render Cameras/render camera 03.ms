(
fn getControllerTimes ctrl &arr =
(
	for i = 1 to ctrl.numSubs do
	(
		local range = getTimeRange ctrl[i].controller
		if range.start - range.end != 0f then
		(
			append arr range.start
			append arr range.end
		)
		getControllerTimes ctrl[i] &arr
	)
)

fn getControllerRange ctrl =
(
	arr	= #()
	getControllerTimes ctrl &arr
	return interval (aMin arr) (aMax arr)
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

(
-- variables

	local pass		= "fg"

	local bPath 	= "E:/02_Current_Jobs/2006-09 - Jetix promo/3 - renders/"
	local cam		= viewport.getCamera()
	local fName 	= cam.name
	local fPath		= bPath + pass + "/" + fName + "/"
	
-- create folder
	createFolder fPath

-- get start and end times
	cRange = getControllerRange cam.transform.controller

-- set up render infomation
	rendOutputFilename = fPath + " "
	rendTimeType	= 3
	rendStart		= cRange.start
	rendEnd			= cRange.end
)

)

renderSceneDialog.update()
renderSceneDialog.open()