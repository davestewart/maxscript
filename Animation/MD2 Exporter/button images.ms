

rollout ro1 "Untitled" width:162 height:300
(
	local bm1
	
	button btn1 "" pos:[8,8] width:18 height:18

	
	
	on ro1 open do
(
		bmImage = openbitmap ((getdir #ui) + "Icons\\bip_layer_i.bmp")
		--bmMask = openbitmap ((getdir #ui) + "Icons\\bip_layer_a.bmp")
		btn1.images = #(bmImage, bmMask, 24, 1, 1, 1, 1)
)
	
)


createdialog ro1