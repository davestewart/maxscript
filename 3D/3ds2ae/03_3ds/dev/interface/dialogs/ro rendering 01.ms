try(destroyDialog roRend);catch()

rollout roRend "Rendering" width:536 height:448
(
	GroupBox grpObj "G-Buffer Manager" pos:[8,8] width:520 height:288
		label lblUnassigned "Un-assigned objects" pos:[16,24] width:248 height:16
		label lblAssigned "Assigned objects" pos:[272,24] width:248 height:16
		ActiveXControl axObj "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,40] width:248 height:248
		button btnAssignObj ">" pos:[264,40] width:8 height:120
		ActiveXControl axChan "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[272,40] width:248 height:248
		button btnRemoveObj "<" pos:[264,168] width:8 height:120

	GroupBox grpScene "Scene Objects" pos:[8,304] width:260 height:40
		dropdownList ddlGet "" pos:[96,318] width:88 height:21 items:#("Layers", "Selection Sets", "Existing G-Buffers", "Materials", "Objects")
		button btnAutoassign "Auto-assign" pos:[16,320] width:64 height:16
		label lblby "by:" pos:[82,320] width:14 height:16
		checkbox chkInc "Inc. children" pos:[184,320] width:78 height:16

	GroupBox grpGBuffer "G-Buffer Channels" pos:[267,304] width:261 height:40
		button btnAdd "Add" pos:[280,320] width:56 height:16
		button btnRename "Rename" pos:[336,320] width:56 height:16
		button btnRemove "Remove" pos:[394,320] width:54 height:16
		checkbox chkAll "All" pos:[448,320] width:48 height:16
		button btn "<" pos:[504,320] width:14 height:16

	GroupBox grpRendering "3dsmax Rendering" pos:[8,352] width:256 height:88
		dropdownList ddl7 "" pos:[16,392] width:240 height:21 items:#("scene | camera | version | frame", "camera | frame")

	GroupBox grpHousekeeping "Housekeeping" pos:[272,352] width:256 height:88
		checkbox chkNameLayers "Name: AE layers from G-Buffer name" pos:[280,368] width:200 height:16 checked:true
		checkbox chkNameEffects "Name: AE effects from G-Buffer name / ID" pos:[280,384] width:200 height:16 checked:true
		checkbox chkCommentProj "Comment: AE project items with max file + camera" pos:[280,400] width:248 height:16 checked:true
		checkbox chkCommentFiles "Comment: files on disk with max file + camera" pos:[280,416] width:246 height:16 checked:true
)

createdialog roRend

/*
for i = 1 to roAnimation.axObj.listitems.count do roAnimation.axObj.listitems[i].forecolor=if (mod i 2 == 1) then (color 255 0 0) else (color 255 255 0)
.backcolor = (color 255 240 240)
*/