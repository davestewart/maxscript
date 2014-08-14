bmi=openBitmap ((getDir #ui)+"\\icons\\Render_16i.bmp")
bma=openBitmap ((getDir #ui)+"\\icons\\Render_16a.bmp")

bmPath="E:\\03_Scripting\\maxScript\\max 5\\3ds to ae\\interface testing\\"
bm1_i=openBitmap (bmPath+"bm1_24i.bmp")
bm1_a=openBitmap (bmPath+"bm1_24a.bmp")
bm2_i=openBitmap (bmPath+"bm2_24i.bmp")
bm2_a=openBitmap (bmPath+"bm2_24a.bmp")

rollout ro "button testing" width:232 height:336
(
	button btn1 "" width:20 height:20 images:#(bmi,bma,10,1,1,1,1) across:5
	button btn2 "" width:20 height:20 images:#(bmi,bma,10,2,2,2,2)
	button btn3 "" width:20 height:20 images:#(bmi,bma,10,3,3,3,3)
	button btn4 "" width:20 height:20 images:#(bmi,bma,10,4,4,4,4)
	button btn5 "" width:20 height:20 images:#(bmi,bma,10,5,5,5,5)

	button btn6 "" width:20 height:20 images:#(bm1_i,bm1_a,1,1,1,1,1) across:2
	button btn7 "" width:20 height:20 images:#(bm2_i,bm2_a,1,1,1,1,1)
)

createdialog ro 140 70

freescenebitmaps()