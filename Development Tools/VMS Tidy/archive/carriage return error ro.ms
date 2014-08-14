--VMS Tidy test rollout

try(destroyDialog VMSTidyVarRo );catch()

rollout VMSTidyVarRo "Enter initialisation variables below.." width:400 height:216
(
	edittext edt1 "" pos:[4,32] width:388 height:160
	button btnPaste "Copy" pos:[8,8] width:64 height:16
	
	button btnCopy "Paste" pos:[72,8] width:64 height:16
	button btn88 "Done" pos:[8,196] width:384 height:16
)
createDialog VMSTidyVarRo 

