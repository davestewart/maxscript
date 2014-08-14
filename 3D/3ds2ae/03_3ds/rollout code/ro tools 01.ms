rollout roTools "Tools" width:400 height:272
(
	-- variables
		local b1=openbitmap "E:/03_Scripting/3ds2ae/03_3ds/rollout code/ui/tool.objectArranger.bmp"

	GroupBox grp1 "Tools" pos:[8,8] width:384 height:256
		bitmap bmp1 "Bitmap" pos:[16,24] width:72 height:72 bitmap:b1
		label lbl1 "Object Arranger" pos:[96,24] width:288 height:16
		label lbl2 "Arrange one object over the surface of another's in a couple of clicks.." pos:[96,40] width:288 height:32
		button btn1 "Run..." pos:[96,80] width:80 height:16
		bitmap bmp2 "Bitmap" pos:[16,104] width:72 height:72 bitmap:b1
		label lbl3 "Object Arranger" pos:[96,104] width:288 height:16
		label lbl4 "Arrange one object over the surface of another's in a couple of clicks.." pos:[96,120] width:288 height:32
		button btn2 "Run..." pos:[96,160] width:80 height:16
		bitmap bmp3 "Bitmap" pos:[16,184] width:72 height:72 bitmap:b1
		label lbl5 "Object Arranger" pos:[96,184] width:288 height:16
		label lbl6 "Arrange one object over the surface of another's in a couple of clicks.." pos:[96,200] width:288 height:32
		button btn3 "Run..." pos:[96,240] width:80 height:16
)

if max2ae==undefined then createdialog roTools