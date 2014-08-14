viewport.setLayout #layout_3vl 
viewArr=#(#view_top,#view_camera,#view_persp_user)

for i = 1 to viewArr.count do
(
	viewport.activeViewport=i
	viewport.setType viewArr[i]
	if viewArr[i] == #view_camera then 
	(
		displaySafeFrames = true
		forcecompleteredraw()
	)
)
max tool zoomextents all


/*

#view_top -- Top
#view_bottom -- Bottom
#view_right -- Right
#view_left -- Left
#view_front -- Front
#view_back -- Back
#view_persp_user -- Perspective
#view_iso_user -- User
#view_camera -- Camera
#view_spot -- Light
#view_shape -- Shape
#view_grid -- Grid

	viewport.activeViewport=4
	*/
	
apropos "safe"