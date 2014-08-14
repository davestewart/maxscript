ctrl = r1.animatedcamera.position.controller



fn getNearestKey ctrl t =
	(
	local keyArr = ctrl.keys
	local k1, k2
	for i = 1 to keyArr.count do
		(
		
		if keyArr[i].time >= t then
			(
			k2 = keyArr[i]
			if i > 1 then k1 = keyArr[i-1] else k1 = k2
			exit
			)
		else
			(
			return keyArr[keyArr.count]
			)
		)
		
	if (t - k1.time) < (k2.time - t) then return k1
	else return k2
	)



fn getNearestKey ctrl t =
	(
	local keyArr = ctrl.keys
	local k1, k2

	if t < keyArr[1].time then return keyArr[1]
	else if t > keyArr[keyArr.count].time then return keyArr[keyArr.count]
	else
		(
		for i = keyArr.count - 1 to 1 by -1 do
			(
			if t > keyArr[i].time then
				(
				k1 = keyArr[i]
				k2 = keyArr[i + 1]
				exit
				)
			)
		if (t - k1.time) < (k2.time - t) then return k1
		else return k2
		)
	)

(
t1 = timestamp()
for i = 1 to 1000 do k = getNearestKey ctrl slidertime
t2 = timestamp()
format "key: % | time: %\n" k.time (t2 - t1)
)



fn updateLbxCameras = 
	(
	-- exit if no animated camera
		if NOT isValidNode animatedcamera
			(
			unregisterTimeCallback tcb_CameraAnimator
			return false
			)
	-- get properties
		local k = getNearestKey animatedcamera.position.controller slidertime
		local t = k.time
		local p = at time t ctrl.value

	-- get camera	
		local cam = (for c in arrCam where c.pos == p and c != animatedCamera collect c)[1]
		local i = tryGetProperty cam.cameraAnimationParameters #order
		
	-- update list
		lbxCameras.selection = #{i}
	)
	

fn tcb_CameraAnimator = updateLbxCameras()

registerTimeCallback tcb_CameraAnimator

unregisterTimeCallback tcb_CameraAnimator

s = sphere()
delete s
isvalidnode s



r1.trygetproperty $.cameraAnimationParameters #order

r1.lbxCameras.selection = #{3}
