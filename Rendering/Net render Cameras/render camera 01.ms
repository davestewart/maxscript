arrTime	= #()
(

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
		getControllerTimes ctrl[i]
		)
	)

local cam		= viewport.getCamera()
local fName 	= cam.name
local fPath 	= "E:/02_Current_Jobs/2006-09 - Jetix promo/3 - renders/"

getControllerTimes cam.transform.controller

rendOutputFilename = fPath + fName + " "
rendTimeType	= 3
rendStart		= aMin arrTime
rendEnd			= aMax arrTime

)
renderSceneDialog.update()
renderSceneDialog.open()
/*
range = getTimeRange $.position.controller[1].controller
getTimeRange $.transform.controller


arrCtrl = #()
arrTime = #()
getControllers $.transform.controller
arrTime 
	
aMax arrTime

	
	
$.transform.controller[1].keys

$.transform.controller[1].controller

range.start as integer
abs (range.end as integer)
range.start - range.end == 0f


$.transform.controller[1].numsubs
*/