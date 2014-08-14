rollout roCustomButtons "Custom Buttons" width:162 height:28
(
	include "iconUtils 02.ms"
	
	button btn1 "?" width:16 height:16 tooltip:"Open" across:5
	button btn2 "?" width:16 height:16 tooltip:"Save"
	button btn3 "?" width:16 height:16 tooltip:"Refresh"
	button btn4 "?" width:16 height:16 tooltip:"Correct"
	button btn5 "?" width:16 height:16 tooltip:"Error!"
	
	on roCustomButtons open do
	(
		icon.setButton btn1 #open
		icon.setButton btn2 #save
		icon.setButton btn3 #refresh fg:blue
		icon.setButton btn4 #tick fg:(green * 0.7)
		icon.setButton btn5 #cross fg:red bg:yellow mask:false
	)
)

createdialog roCustomButtons
