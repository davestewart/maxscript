--showallactivexcontrols()

rollout ro1 "AX Rollout" width:474 height:371
(
	dropDownList ddl1 "" pos:[9,299] width:100 height:21 items:#("1", "2", "3", "4") selection:1
	ActiveXControl ax "FlexCell.Grid" pos:[8,8] width:424 height:280


	on ddl1 selected val do ax.activecell.text = val
	
	on ax Click do
	(
		local x = ax.activecell.top + 8
		local y = ax.activecell.left + 8
		ro1.ddl1.pos	=[y,x]
		ro1.ddl1.width	=ax.activecell.width
	)
	
)


createdialog ro1

--ax.enabled=false


--(ax.cell 1 1).text = "dave"
	


showevents ax

/*



enableAccelerators = false



fn test=
(
	local ss=stringstream ""
	showMethods ax to:ss 
)
	
test()
classof propArr[3].value


arr = execute ss
ss
arr = getPropNames ax 

for a in arr do print a



ss

showmethods ax


classof (getproperty ax #Calendar)



ax.ActiveCell.CellType =#cellComboBox 
(ax.cell 2 2).text="dave"


for i = 1 to 10 do (ax.cell i 1).text=i as string
for i = 1 to 10 do (ax.cell i 1).CellType =#cellComboBox 




showmethods (ax.cell 1 1)

(ax.cell 1 1).SetFocus()

showmethods (ax.cell 1 1)

showevents ax

*/

ax = ro1.ax