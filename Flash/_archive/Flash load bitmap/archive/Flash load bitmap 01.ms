
rollout r1 "Flash Load Bitmap Test" width:312 height:344
(
	ActiveXControl ax "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[8,8] width:296 height:300
	button btn1 "Load Image 1" pos:[8,312] width:144 height:24
	button btn2 "Load Image 2" pos:[160,312] width:144 height:24


	fn flashLoadBitmap bm =
	(
		ax.SetVariable "bitmap" bm
		ax.TCallLabel "_root" "loadBitmap"
	)

	on r1 open do
	(
		local flashPath	="E:/03_Scripting/maxScript/max 8/Flash load bitmap/"
		ax.movie		=flashPath+"loadBitmap.swf"
	)
		
	on btn1 pressed do flashLoadBitmap "bitmap1.jpg"
	on btn2 pressed do flashLoadBitmap "bitmap2.jpg"

)
destroydialog r1
createdialog r1