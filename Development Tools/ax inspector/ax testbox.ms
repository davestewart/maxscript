rollout ro1 "Untitled" width:162 height:300
(
	--activeXControl ax1 "RICHTEXT.RichtextCtrl.1" pos:[8,8] width:144 height:136
	activeXControl ax1 "Forms.TextBox.1" pos:[8,8] width:144 height:136

	on ro1 open do
		(
		--ax1.ScrollBars = #rtfVertical 
		enableAccelerators = true
		)
	on ro1 close do enableAccelerators = false
)
createdialog ro1
/*

showproperties ro1.ax1
 enableAccelerators = false


setProperty ro1.ax1 "ScrollBars" #rtfVertical 


showmethods ro1.ax1
*/

print 2

a = 1
gc()

a