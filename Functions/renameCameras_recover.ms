function renameCameras =
(
	local i = 1
	local camArray = for c in cameras where superclassof c == camera collect c
	for c in camArray do
	(
		local numStr = pad i
		local camName = "Camera" + numStr
		local trgName = camName + ".Target"
		c.name = camName
		if c.target != undefined then
		(
			c.target.name = trgName
		)
		i += 1
	)
)

--renameCameras ()




fn setControllerKeyType ctrl type =
(
		if ctrl.numsubs == 0 then
		(
			for k in ctrl.keys do
			(
				k.inTangentType = type
				k.outTangentType = type
			)
		)
		else
		(
			for i = 1 to ctrl.numsubs do setControllerKeyType ctrl[i] type 
		)
			/*
	if (isController ctrl) then
	(
	)
	else( format "% is not a controller!\n" ctrl)
	*/
)

function animateCameraThroughExistingCameras =
(
	-- grab existing animated camera or create new one
		camName = "Animated Camera"
		c = getNodeByName camName
		if NOT isvalidnode c then
		(
			c = Targetcamera target:(Targetobject()) name:camName
			c.target.name = c.name+".Target"
			c.wirecolor = c.target.wirecolor = color 0 255 0
		)
			
	-- delete keys of animated camera
		local ctrlCam = $'Animated Camera'.position.controller
		local ctrlTrg = $'Animated Camera'.target.position.controller
		
		for i = 1 to ctrl.numsubs do deleteKeys ctrlCam[i] #allkeys
		for i = 1 to ctrl.numsubs do deleteKeys ctrlTrg[i] #allkeys

	
	-- get existing cameras
		camArray = for c in cameras where superclassof c == camera AND c.name != camName collect c
	
		
	-- local variables
		moveTime = 25
		holdTime = 75
		
	-- loop thorugh cameras
		for i = 1 to camArray.count do
		(
			local tStart = (i-1) * (moveTime + holdTime)
			local tEnd = tStart + holdTime
			
			format "start:% End:%\n" tStart tEnd
			
			local srcPos
			local trgPos
		
			with animate on at time tStart
			(
				--format "% %\n" camArray[i].name camArray[i].target--transform
				c.transform = camArray[i].transform
				c.target.transform = camArray[i].target.transform
				c.fov = camArray[i].fov
			)
				
			with animate on at time tEnd
			(
				--format "% %\n" camArray[i].name camArray[i].target--transform
				c.transform = camArray[i].transform
				c.target.transform = camArray[i].target.transform
				c.fov = camArray[i].fov
			)
		)
	-- set camera keys to slow
		setControllerKeyType c.position.controller #slow
		setControllerKeyType c.target.position.controller #slow
		setControllerKeyType c.fov.controller #slow
	
	
	-- select camera
		select c
		if querybox "Set viewport to camera?" then max vpt camera
		--select #(c,c.target)
		--clearSelection()
)


function matchCamera c1 = 
(
	c2 = pickobject ()
	c1.pos = c2.pos
	c1.target.pos = c2.target.pos
)

--matchCamera $

	
(
renameCameras()
animateCameraThroughExistingCameras()
)

/*
ctrl = c.position.controller
ctrl = cameras[1].transform.controller
superclassof ctrl

ctrl2 = c.position.controller[1]
setControllerKeyType ctrl #slow

ctrl = c.position.controller
setControllerKeyType ctrl #slow

isController ctrl

*/

/*
--$.wirecolor = (pickobject()).wirecolor
function setAllGroupsOpen state =
(
	for obj in helpers do if isGroupHead obj then setGroupOpen obj state
)
	
openAllGroups false
hide cameras

setAllGroupsOpen false
*/

unhide $'comp - books'