/*
CreateDialog <Rollout> [<height> <width> <position_x> <position_y>]\ 

[pos:<Point2>] [width:<integer>] [height:<integer>] \ 

[bgcolor:<color>] [fgcolor:<color>] \ 

[bitmap:<bitmap>] {bmpstyle:<bmpstyle> \ 

[menu:<RCMenu>] [style:<array>] [modal:<boolean>] [escapeEnable:<boolean>] 

NEW in 3ds max 5: When the optional modal:<boolean> keyword is set to true, the dialog ignores all user interactions except those within the dialog. Call DestroyDialog() to close it, presumably in a scripted OK button. The user can also close a modal scripted dialog by hitting the Escape key as long as escapeEnable keyword is set to false or not supplied. 

*/
global pmOptFloater
global roOpts
rollout roOpts "Options" width:338 height:241
(
	button btnCopyVal "Copy values" pos:[192,128] width:104 height:16
		
	button btnCopyCtrl "Copy controllers" pos:[192,160] width:104 height:16
	button btnInstCtrl "Instance controllers" pos:[192,176] width:104 height:16
	button BtnCancel "Cancel" pos:[16,64] width:96 height:16
	radioButtons rdo1 "" pos:[8,8] width:111 height:48 labels:#("Copy values only", "Copy controller", "Instance Controller")
	on btnCopyVal pressed do
		DestroyDialog roOpts
	on btnCopyCtrl pressed do
		DestroyDialog roOpts
	on btnInstCtrl pressed do
		DestroyDialog roOpts
	on BtnCancel pressed do
		DestroyDialog roOpts
	on rdo1 changed stat do
(
	
	)
)/*
	if pmOptFloater != undefined then closerolloutfloater pmOptFloater
		pmOptFloater = newRolloutFloater "Property Matcher Options" 188 200 
	addRollout roOpts pmOptFloater
*/

CreateDialog roOpts 104 128 50 50 modal:true --style:#(#style_toolwindow)
\ 

[pos:<Point2>] [width:<integer>] [height:<integer>] \ 

[bgcolor:<color>] [fgcolor:<color>] \ 

[bitmap:<bitmap>] {bmpstyle:<bmpstyle> \ 

