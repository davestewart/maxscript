pos1 = [50,2,3]

fn testFN = (
	max views redraw
	gw.setColor #line green
	gw.resetUpdateRect()
	gw.enlargeUpdateRect #whole
	-- get the update rectangle dimensions
	ur = gw.getUpdateRect()
	wX = ur.w - 2
	wY = ur.h - 2
	
	local x = mouse.pos[1]
	local y = mouse.pos[2]
	local s = 30
	
	if findItem mouse.buttonStates 1 == 1 then pos1 = mouse.pos
	local pos2 = mouse.pos
	
	-- draw the box
	--gw.wPolyline #([0,0,0], [wX,0,0], [wX,wY,0], [0,wY,0]) true 
	--gw.wPolyline #([x-s,y-s,0], [x+s,y-s,0], [x+s,y+s,0], [x-s,y+s,0]) true 
	-- update the viewports 
	
	--gw.wPolyline #([pos1[1],pos1[2],0], [pos2[1],pos2[2],0]) true 
	gw.wPolyline #([pos1[1],pos1[2],3], [pos2[1],pos2[2],0]) true 
	
	gw.updateScreen()
	--pos1 = mouse.pos
)
	
fn cbCaller = testFN()

rollout testRlt "test" (
	checkbutton testBtn "test"
	
	on testBtn changed val do (
		if val then
		(
			registerRedrawViewsCallback cbCaller 
		)
		else
		(
			unregisterRedrawViewsCallback cbCaller
			max views redraw
		)
	)
		
	on testRlt close do unregisterRedrawViewsCallback cbCaller
)

createDialog testRlt
